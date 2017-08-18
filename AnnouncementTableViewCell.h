//
//  AnnouncementTableViewCell.h
//  MySampleApp
//
//  Created by Jong Yun Lee on 3/17/17.
//
//

#import <UIKit/UIKit.h>

@interface AnnouncementTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@end
