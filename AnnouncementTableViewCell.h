//
//  AnnouncementTableViewCell.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/17/17.
//
//

#import <UIKit/UIKit.h>

@interface AnnouncementTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
