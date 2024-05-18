package main

import (
	"os"

	ctrl "k8s.io/apimachinery/pkg/runtime"
)

// func main() {
// 	// Create a scheme with native resources and the Custom resource, MyResource
// 	scheme := runtime.NewScheme()
// 	clientgoscheme.AddToScheme(scheme)
// 	mygroupv1alpha1.AddToScheme(scheme)

// 	//  Create a Manager using the scheme just created
// 	mgr, err := manager.New(config.GetConfigOrDie(), manager.Options{Scheme: scheme})
// 	panicIf(err)

// 	// Create a Controller, attached to manager, passing a Reconciler implementation
// 	controller, err := controller.New("my-operator", mgr, controller.Options{Reconciler: &MyReconciler{}})
// 	panicIf(err)

// 	// Start watching MyResource instances as a primary resource
// 	err = controller.Watch(
// 		&source.Kind{
// 			Type: &mygroupv1alpha1.MyResource{},
// 		},
// 		&handler.EnqueueRequestForObject{},
// 	)
// 	panicIf(err)

// 	// Start watching Pod instances as an owned resource
// 	err = controller.Watch(
// 		&source.Kind{
// 			Type: &corev1.Pod{},
// 		},
// 		&handler.EnqueueRequestForOwner{
// 			OwnerType:    &corev1.Pod{},
// 			IsController: true,
// 		},
// 	)
// 	panicIf(err)

// 	// Start the manager. This function is long-running and only will return if an error occurs
// 	err = mgr.Start(context.Background())
// 	panicIf(err)
// }

// // A type implementing the Reconciler interface
// type MyReconciler struct{}

// // Implementation of the Reconcile method. This will display thenamespace and name of the instance to reconcile
// func (o *MyReconciler) Reconcile(ctx context.Context, r reconcile.Request) (reconcile.Result, error) {
// 	fmt.Printf("reconcile %v\n", r)
// 	return reconcile.Result{}, nil
// }

// // panicIf panic if err is not nil
// // Please call from main only!
// func panicIf(err error) {
// 	if err != nil {
// 		panic(err)
// 	}
// }
