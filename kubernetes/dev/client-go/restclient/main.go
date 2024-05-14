package main

import (
	"context"
	"flag"
	"fmt"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/klog/v2"
)

func main() {
	klog.InitFlags(nil)
	flag.Parse()

	ctx := context.Background()
	config, err := getConfig()
	if err != nil {
		panic(err)
	}

	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	// # Getting result as table
	restClient := clientset.CoreV1().RESTClient() // Get the RESTClient for the core/v1 group
	req := restClient.Get().
		Namespace("project1"). // Indicate the namespace from which to list the resources
		Resource("pods").      // Indicate the resources to list
		SetHeader(             // Set the required header to get the result as tabular information
			"Accept",
			fmt.Sprintf("application/json;as=Table;v=%s;g=%s", metav1.SchemeGroupVersion.Version, metav1.GroupName))

	var result metav1.Table // Prepare a variable of type metav1.Table to store the result of the request
	err = req.Do(ctx).      // Execute the request
				Into(&result) // Store the result in the metav1.Table object
	if err != nil {
		panic(err)
	}

	for _, colDef := range result.ColumnDefinitions { // Range over the definitions of the columns returned to display the table header
		// display header
		fmt.Printf("%v\t", colDef.Name)
	}
	fmt.Printf("\n")

	for _, row := range result.Rows { // Range over the rows of the table returned to display the row of data containing information about a specific pod
		for _, cell := range row.Cells { // Range over the cells of the row to display them
			// display cell
			fmt.Printf("%v\t", cell)
		}
		fmt.Printf("\n")
	}
}

func getConfig() (*rest.Config, error) {
	return clientcmd.NewNonInteractiveDeferredLoadingClientConfig(
		clientcmd.NewDefaultClientConfigLoadingRules(),
		nil,
	).ClientConfig()
}
