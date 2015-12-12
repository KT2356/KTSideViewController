# KTSideViewController
The side view controller like drawing view out
####Useage
 FirstViewController *firstVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstViewController"];
    SecontViewController *secondVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SecontViewController"];
    
    KTSideViewController *mainViewController=[[KTSideViewController alloc]initWithBackViewContorller:secondVC
                                                                                 FrontViewController:firstVC];
