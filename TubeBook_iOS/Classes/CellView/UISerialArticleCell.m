//
//  UISerialArticleCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UISerialArticleCell.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "TopicArticleContent.h"
#import "SerialArticleContent.h"

@implementation UISerialArticleCell

- (instancetype)initWithDateType:(CKDataType *)type
{
    self = [super initWithDateType:type];
    if (self) {
        self.homeCellItemHeadView = [[UIHomeCellItemHeadView alloc] initUIHomeCellItemHeadView:type.userState];
        self.homeCellItemContentView = [[UIHomeCellItemContentView alloc] initUIHomeCellItemContentView:type.isHaveImage];
        self.homeCellItemFootView = [[UIHomeCellItemFootView alloc] initUIHomeCellItemFootView:type.userState];
        self.homeCellTopicOrSerialView = [[UIHomeCellTopicOrSerialView alloc] initUIHomeCellTopicOrSerialView:SerialArticle];
        
        [self.contentView addSubview:self.homeCellItemHeadView];
        [self.contentView addSubview:self.homeCellItemContentView];
        [self.contentView addSubview:self.homeCellItemFootView];
        [self.contentView addSubview:self.homeCellTopicOrSerialView];
        
        [self.homeCellItemHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(8);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo([self.homeCellItemHeadView getUIHeight]);
        }];
        [self.homeCellItemContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.homeCellItemHeadView.mas_bottom);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo([self.homeCellItemContentView getUIHeight]);
        }];
        [self.homeCellTopicOrSerialView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.homeCellItemContentView.mas_bottom);
            make.right.equalTo(self.contentView).offset(-16);
            make.height.mas_equalTo([self.homeCellTopicOrSerialView getUIHeight]);
        }];
        [self.homeCellItemFootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.homeCellTopicOrSerialView.mas_bottom);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo([self.homeCellItemFootView getUIHeight]);
        }];
        UITapGestureRecognizer *tapAvatarGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSerialTab)];
        [self.homeCellTopicOrSerialView addGestureRecognizer:tapAvatarGesturRecognizer];
        [self.homeCellTopicOrSerialView setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)tapSerialTab
{
    TubeRefreshTableViewController *controller = self.viewController;
    if ([controller.keyForIndexBlockDictionary objectForKey:kSerialTabViewTap]) {
        tapForIndexBlock block = [controller.keyForIndexBlockDictionary objectForKey:kSerialTabViewTap];
        block([controller.refreshTableView indexPathForCell:self]);
    }
}

- (CGFloat)getCellHeight
{
    CGFloat height = 0;
    if (self.homeCellItemHeadView && self.homeCellItemContentView && self.homeCellItemFootView && self.homeCellTopicOrSerialView) {
        height = [self.homeCellItemFootView getUIHeight] + [self.homeCellItemContentView getUIHeight] + [self.homeCellItemHeadView getUIHeight] + [self.homeCellTopicOrSerialView getUIHeight];
    }
    return height + 16;
}

+ (CGFloat)getCellHeight:(CKContent *)content
{
    return [UIHomeCellItemHeadView getUIHeight:content.dataType.userState] + [UIHomeCellItemContentView getUIHeight:content.dataType.isHaveImage] + [UIHomeCellItemFootView getUIHeight:content.dataType.userState] + [UIHomeCellTopicOrSerialView getUIHeight:content.dataType.articleKind] + 16;
}

- (void)setContent:(CKContent *)content
{
    if ([content isKindOfClass:[SerialArticleContent class]]) {
        SerialArticleContent *atContent =  (SerialArticleContent *)content;
        [self.homeCellItemHeadView setDataWithAvatarUrl:atContent.avatarUrl userName:atContent.userName time:atContent.time userState:atContent.dataType.userState];
        [self.homeCellItemContentView setDataWithTitle:atContent.articleTitle contentDescription:atContent.articleDescription contentUrl:atContent.articlePic];
        [self.homeCellTopicOrSerialView setDataWithTitle:atContent.serialTitle tagImageUrl:atContent.serialImageUrl detail:content.serialDescription];

    }
}


@end
