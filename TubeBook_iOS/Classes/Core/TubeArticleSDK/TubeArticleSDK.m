//
//  TubeArticleSDK.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeArticleSDK.h"

@interface TubeArticleSDK ()

@property (nonatomic, strong) TubeArticleManager *articleManager;

@end

@implementation TubeArticleSDK

- (instancetype)initTubeArticleSDK:(TubeServerDataSDK *)tubeServer
{
    self = [super init];
    if (self) {
        self.articleManager = [[TubeArticleManager alloc] initTubeArticleManagerWithSocket:tubeServer];
    }
    return self;
}

- (void)fetchedArticleTagListWithCount:(NSInteger)count callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleTagListWithCount:count callBack:callBack];
}

- (void)addArticleTag:(NSString *)tag callBack:(dataCallBackBlock)callBack
{
    [self.articleManager addArticleTag:tag callBack:callBack];
}

- (void)fetchedArticleTopicTitleListWithIndex:(NSInteger)index uid:(NSString *)uid fouseType:(FouseType)fouseType conditionDic:(NSDictionary *)conditionDic callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleTopicTitleListWithIndex:index uid:uid fouseType:fouseType conditionDic:conditionDic callBack:callBack];
}

/*
 * @brief 获取某专题详细信息
 */
- (void)fetchedArticleTopicDetailWithTabid:(NSInteger)tabid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleTopicDetailWithTabid:tabid callBack:callBack];
}

/*
 * @brief 上传文章
 * @parme detailDic 为可设内容
 */
- (void)uploadArticleWithTitle:(nonnull NSString *)title atid:(nonnull NSString *)atid uid:(nonnull NSString *)uid detail:(NSDictionary *)detailDic callBack:(dataCallBackBlock)callBack
{
    [self.articleManager uploadArticleWithTitle:title atid:atid uid:uid detail:detailDic callBack:callBack];
}

/*
 * @brief 设置文章标签
 */
- (void)setArticleTagWithAtid:(nonnull NSString *)atid tags:(NSArray *)tags callBack:(dataCallBackBlock)callBack;

{
    [self.articleManager setArticleTagWithAtid:atid tags:tags callBack:callBack];
}

/*
 * @brief 设置文章类别
 */
- (void)setArticleTabWithAtid:(nonnull NSString *)atid articleType:(ArticleType)articleType tabid:(NSInteger)tabid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager setArticleTabWithAtid:atid articleType:articleType tabid:tabid callBack:callBack];
}

/*
 * @brief 获取连载标题信息列表
 */
- (void)fetchedArticleSerialTitleListWithIndex:(NSInteger)index
                                           uid:(NSString *)uid
                                     fouseType:(FouseType)fouseType
                                  conditionDic:(NSDictionary *)conditionDic
                                      callBack:(dataCallBackBlock)callBack{
    [self.articleManager fetchedArticleSerialTitleListWithIndex:index uid:uid fouseType:fouseType conditionDic:conditionDic callBack:callBack];
}

/*
 * @brief 获取某连载详细信息
 */
- (void)fetchedArticleSerialDetailWithTabid:(NSInteger)tabid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleSerialDetailWithTabid:tabid callBack:callBack];
}

/*
 * @brief 获取专题/连载标题信息列表
 */
- (void)fetchedArticleTopicOrSerialTitleListWithType:(ArticleType)articleType
                                               index:(NSInteger)index
                                                 uid:(NSString *)uid
                                           fouseType:(FouseType)fouseType
                                        conditionDic:(NSDictionary *)conditionDic
                                            callBack:(dataCallBackBlock)callBack
{
    if ( articleType == ArticleTypeTopic ) {
        [self fetchedArticleTopicTitleListWithIndex:index uid:uid fouseType:fouseType conditionDic:conditionDic callBack:callBack];
    } else if ( articleType == ArticleTypeSerial ) {
        [self fetchedArticleSerialTitleListWithIndex:index uid:uid fouseType:fouseType conditionDic:conditionDic callBack:callBack];
    }
}

/*
 * @brief 获取最新文章(普通/专题/连载)列表,
 * @parme tabid专题/连载某标题tabid的最新
 * uid 为空代表全部
 * tabid 当文章为普通文章时tabid不起作用 articleType多个时tabid不起作用
 */
- (void)fetchedNewArticleListWithIndex:(NSInteger)index
                                   uid:(NSString *)uid
                           articleType:(ArticleType)articleType
                                 tabid:(NSInteger)tabid
                          conditionDic:(NSDictionary *)conditionDic
                              callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedNewArticleListWithIndex:index uid:uid articleType:articleType tabid:tabid conditionDic:conditionDic callBack:callBack];
}

/*
 * @brief 获取文章详细信息
 */
- (void)fetchedArticleContentWithAtid:(NSString *)atid uid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleContentWithAtid:atid uid:uid callBack:callBack];
}

/*
 * @brief 设置文章为喜欢的
 */
- (void)setArticleToLikeWithLikeStatus:(BOOL)likeStatus atid:(NSString *)atid uid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager setArticleToLikeWithLikeStatus:likeStatus atid:atid uid:uid callBack:callBack];
}

/*
 * @brief 文章喜欢未读数
 */
- (void)fetchedLikeNotReviewCount:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedLikeNotReviewCount:uid callBack:callBack];
}

/*
 * @brief 创建专题/连载
 */
- (void)createTopicOrSerialTabWithUid:(NSString *)uid
                                 type:(ArticleType)type
                                title:(NSString *)title
                          description:(NSString *)description
                                  pic:(NSString *)pic
                              allBack:(dataCallBackBlock)callBack
{
    [self.articleManager createTopicOrSerialTabWithUid:uid type:type title:title description:description pic:pic allBack:callBack];
}

/*
 * @brief 按热度获取推荐文章(普通/专题/连载)列表
 */
- (void)fetchedRecommendByHotArticleListtWithIndex:(NSInteger)index uid:(NSString *)uid articleType:(ArticleType)articleType fouseType:(FouseType)fouseType callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedRecommendByHotArticleListtWithIndex:index uid:uid articleType:articleType fouseType:fouseType callBack:callBack];
}

/*
 * @brief 按基于用户推荐算法获取推荐文章(普通/专题/连载)列表
 */
- (void)fetchedRecommendByUserCFArticleListtWithIndex:(NSInteger)index uid:(NSString *)uid articleType:(ArticleType)articleType callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedRecommendByUserCFArticleListtWithIndex:index uid:uid articleType:articleType callBack:callBack];
}

/*
 * @brief 获取文章是否喜欢
 */
- (void)fetchedArticleLikeStatusWithAtid:(NSString *)atid uid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleLikeStatusWithAtid:atid uid:uid callBack:callBack];
}

/*
 * @brief 获取用户对某专题/连载的关注状态
 */
- (void)fetchedTabLikeStatusWithTabid:(NSInteger)tabid uid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedTabLikeStatusWithTabid:tabid uid:uid callBack:callBack];
}

/*
 * @brief 设置某个专题/连载为关注
 */
- (void)setArticleTabWithLikeStatus:(BOOL)likeStatus tabid:(NSInteger)tabid uid:(NSString *)uid articleType:(ArticleType)articleType callBack:(dataCallBackBlock)callBack
{
    [self.articleManager setArticleTabWithLikeStatus:likeStatus tabid:tabid uid:uid articleType:articleType callBack:callBack];
}

/*
 * @brief 获取喜欢的文章列表
 */
- (void)fetchedUserLikeArticleListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedUserLikeArticleListWithIndex:index uid:uid callBack:callBack];
}

/*
 * @brief 评论文章
 */
- (void)commentArticleWithAtid:(NSString *)atid fromUid:(NSString *)fromUid toUid:(NSString *)toUid message:(NSString *)message callBack:(dataCallBackBlock)callBack
{
    [self.articleManager commentArticleWithAtid:atid fromUid:fromUid toUid:toUid message:message callBack:callBack];
}

/*
 * @brief 获取评论列表
 */
- (void)fetchedArticleCommentListWithAtid:(NSString *)atid index:(NSInteger)index allBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleCommentListWithAtid:atid index:index allBack:callBack];
}

/*
 * @brief 评论回复
 */
- (void)commmentUserWithAtid:(NSString *)atid cid:(NSInteger)cid fromeUid:(NSString *)fromUid toUid:(NSString *)toUid message:(NSString *)message  commentId:(NSInteger)commentId callBack:(dataCallBackBlock)callBack{
    [self.articleManager commmentUserWithAtid:atid cid:cid fromeUid:fromUid toUid:toUid message:message commentId:commentId callBack:callBack];
}

/*
 * @brief 获取评论回复列表
 */
- (void)fetchedUserCommentToUserListWithCid:(NSInteger)cid index:(NSInteger)index allBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedUserCommentToUserListWithCid:cid index:index allBack:callBack];
}

/*
 * @brief 获取某两个人评论回复列表
 */
- (void)fetchedUserCommentToUserListWithCid:(NSInteger)cid fromeUid:(NSString *)fromUid toUid:(NSString *)toUid tid:(NSInteger)tid commentId:(NSInteger)commentId commentType:(NSInteger)commentType allBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedUserCommentToUserListWithCid:cid fromeUid:fromUid toUid:toUid tid:tid commentId:commentId commentType:commentType allBack:callBack];
}

/*
 * @brief 获取评论未读数
 */
- (void)fetchedCommentNotReviewCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedCommentNotReviewCountWithUid:uid callBack:callBack];
}

/*
 * @brief 获取收到评论列表
 */
- (void)fetchedReceiveCommentListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedReceiveCommentListWithIndex:index uid:uid callBack:callBack];
}

/*
 * @brief 获取针对cid的一条文章评论
 */
- (void)fetchedArticleCommentByCid:(NSInteger)cid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleCommentByCid:cid callBack:callBack];
}

/*
 * @brief 设置评论查看状态
 */
- (void)setCommentReviewStatusWithId:(NSInteger)tid commentType:(NSInteger)commentType callBack:(dataCallBackBlock)callBack
{
    [self.articleManager setCommentReviewStatusWithId:tid commentType:commentType callBack:callBack];
}

/*
 * @brief 获取收到用户喜欢自己文章列表
 */
- (void)fetchedReceiveUserLikeArticleListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedReceiveUserLikeArticleListWithIndex:index uid:uid callBack:callBack];
}

/*
 * @brief 获取用户写的文章个数
 */
- (void)fetchedUserCreateArticleCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedUserCreateArticleCountWithUid:uid callBack:callBack];
}

@end
