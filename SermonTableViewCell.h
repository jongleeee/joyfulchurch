//
//  SermonTableViewCell.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/16/17.
//
//

#import <UIKit/UIKit.h>

@interface SermonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@end
