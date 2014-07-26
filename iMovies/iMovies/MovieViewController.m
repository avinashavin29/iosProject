//
//  MovieViewController.m
//  iMovies
//
//  Created by Badri on 25/07/14.
//  Copyright (c) 2014 Badri. All rights reserved.
//

#import "MovieViewController.h"
#import "AppDelegate.h"
#import "Movies.h"
#import "DetailMovieViewController.h"

@interface MovieViewController ()
@property (nonatomic , retain) NSMutableArray *movieList;
@property (nonatomic , retain) IBOutlet UITableView *tableView;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray *moviesArray;
@property (nonatomic, retain) DetailMovieViewController *detailMovieViewController;
@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Movies";
    
    _movieList = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithRed:114.0/255.0 green:193.0/255.0 blue:216.0/255.0 alpha:1.0];

    _tableView.rowHeight = 50.0;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Movies" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
    jsonString = [self stringByRemovingControlCharacters:jsonString];
    
    NSError *e = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    }
    else {
        _movieList = [[jsonArray valueForKey:@"Movies"] valueForKey:@"Movie"];
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _managedObjectContext = delegate.managedObjectContext;
    
    [self deleteAllObjects:@"Movies"];
    [self savemovieDetails:_movieList];

    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error])
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//abort();
	}
}

- (void)deleteAllObjects: (NSString *) entityDescription  {
	
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
	
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
    for (NSManagedObject *managedObject in items) {
        [_managedObjectContext deleteObject:managedObject];
    }
	
    if (![_managedObjectContext save:&error]) {
		NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
}

- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}

- (void)savemovieDetails:(NSMutableArray *)movieDetails
{
    if (!movieDetails) {
		return;
	}
    
    id cate = [self checkExistanceInBabyDetails:[movieDetails valueForKey:@"movieName"]];
	if(cate){
		return;
	}
    
		
	for(NSMutableDictionary *dict in movieDetails)
	{
        Movies *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Movies" inManagedObjectContext:_managedObjectContext];
        [newManagedObject setValuesForKeysWithDictionary:dict];
	}
	NSError *error = nil;
	
	if (![_managedObjectContext save:&error])
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//abort();
	}
}

-(id)checkExistanceInBabyDetails:(NSString*)name
{
	@try {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movies" inManagedObjectContext:_managedObjectContext];
		[fetchRequest setEntity:entity];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movieName=%@",name];
		[fetchRequest setPredicate:predicate];
		[fetchRequest setFetchBatchSize:10];
		
		NSArray *filtered_array = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
		
        //NSLog(@"the filtered array count is %d",filtered_array.count);
		if (filtered_array != nil && filtered_array.count>0) {
			return [filtered_array objectAtIndex:0];
		} else {
			return nil;
		}
		
	}
	@catch (NSException * e) {
		//NSLog(@"Exception %@ in Cheching for Dublicate Feed",e);
	}
	return nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movies" inManagedObjectContext:_managedObjectContext];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"movieName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	_fetchedResultsController = aFetchedResultsController;
    
	return _fetchedResultsController;
}

- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    cell.backgroundColor = [UIColor colorWithRed:114.0/255.0 green:193.0/255.0 blue:216.0/255.0 alpha:1.0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    Movies *movies = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [movies valueForKey:@"movieName"];
    cell.detailTextLabel.text = [movies valueForKey:@"cast"];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Movies *movie = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    _detailMovieViewController = [[DetailMovieViewController alloc]init];
    [_detailMovieViewController setMovies:movie];
    [self.navigationController pushViewController:_detailMovieViewController animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
