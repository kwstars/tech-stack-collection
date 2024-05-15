package main

import (
	"context"

	myresourcev1alpha1 "github.com/kwstars/controller-sample/pkg/apis/mygroup.example.com/v1alpha1"
	clientset "github.com/kwstars/controller-sample/pkg/generated/clientset/versioned"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/klog/v2"
)

func main() {
	config, err := clientcmd.NewNonInteractiveDeferredLoadingClientConfig(
		clientcmd.NewDefaultClientConfigLoadingRules(),
		nil,
	).ClientConfig()
	if err != nil {
		klog.Fatal(err)
	}

	clientset, err := clientset.NewForConfig(config)
	if err != nil {
		klog.Fatal(err)
	}

	list, err := clientset.MygroupV1alpha1().
		MyResources("default").
		List(context.Background(), metav1.ListOptions{})
	if err != nil {
		klog.Fatal(err)
	}

	for _, res := range list.Items {
		klog.Infof("%s\n", res.GetName())
	}

	// # Using the unstructured package and dynamic client
	// ## The Unstructured type
	u, err := getResource()
	if err != nil {
		klog.Fatal(err)
	}

	// ## Converting between typed and unstructured objects
	converter := runtime.DefaultUnstructuredConverter

	// ### Unstructured to Typed
	var myresource myresourcev1alpha1.MyResource
	converter.FromUnstructured(u.UnstructuredContent(), &myresource)

	klog.Infof("%s, %s\n", myresource.Spec.Image, &myresource.Spec.Memory)

	// ### Typed to Unstructured
	var newU unstructured.Unstructured
	newU.Object, err = converter.ToUnstructured(&myresource)
	if err != nil {
		klog.Fatal(err)
	}

	image, found, err := unstructured.NestedString(newU.Object, "spec", "image")
	if err != nil {
		klog.Fatal(err)
	}
	if !found {
		klog.Fatal("spec.image not found")
	}
	memory, found, err := unstructured.NestedString(newU.Object, "spec", "memory")
	if err != nil {
		klog.Fatal(err)
	}
	if !found {
		klog.Fatal("spec.memory not found")
	}
	klog.Infof("%s, %s\n", image, memory)

	// # The dynamic client
	dynamicClient, err := dynamic.NewForConfig(config)
	if err != nil {
		klog.Fatal(err)
	}

	err = DeleteMyResource(dynamicClient, u)
	if err != nil {
		klog.Fatal(err)
	}
	// _ = createdU
}
