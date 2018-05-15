//
//  TubeArticleManager.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/31.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeArticleConst.h"
#import "TubeServerDataSDK.h"
#import "BaseTubeServerManager.h"

@interface TubeArticleManager : BaseTubeServerManager

- (instancetype)initTubeArticleManagerWithSocket:(TubeServerDataSDK *)tubeServer;

/*
 * @brief 获取标签
 */
- (void)fetchedArticleTagListWithCount:(NSInteger)count callBack:(dataCallBackBlock)callBack;

/*
 * @brief 添加标签
 */
- (void)addArticleTag:(NSString *)tag callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取专题标题信息列表
 * @parme uid 为空代表所有, 不为空代表取关注
 */
- (void)fetchedArticleTopicTitleListWithIndex:(NSInteger)index
                                          uid:(NSString *)uid
                                    fouseType:(FouseType)fouseType
                                 conditionDic:(NSDictionary *)conditionDic callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取某专题详细信息
 */
- (void)fetchedArticleTopicDetailWithTabid:(NSInteger)tabid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 上传文章
 * @parme detailDic 为可设内容
 */
- (void)uploadArticleWithTitle:(nonnull NSString *)title
                          atid:(nonnull NSString *)atid
                           uid:(nonnull NSString *)uid
                        detail:(NSDictionary *)detailDic
                      callBack:(dataCallBackBlock)callBack;

/*
 * @brief 设置文章标签
 */
- (void)setArticleTagWithAtid:(nonnull NSString *)atid tags:(NSArray *)tags callBack:(dataCallBackBlock)callBack;

/*
 * @brief 设置文章类别
 */
- (void)setArticleTabWithAtid:(nonnull NSString *)atid articleType:(ArticleType)articleType tabid:(NSInteger)tabid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取连载标题信息列表
 */
- (void)fetchedArticleSerialTitleListWithIndex:(NSInteger)index
                                           uid:(NSString *)uid
                                     fouseType:(FouseType)fouseType
                                  conditionDic:(NSDictionary *)conditionDic
                                      callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取某连载详细信息
 */
- (void)fetchedArticleSerialDetailWithTabid:(NSInteger)tabid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取关注的作者列表
 */
- (void)fetchedUserInfoListWithIndex:(NSInteger)index fouseType:(FouseType)fouseType;

/*
 * @brief 获取最新文章(普通/专题/连载)列表,
 * @parme tabid专题/连载某标题tabid的最新
 * uid 为空代表全部
 * tabid 当文章为普通文章时tabid不起作用
 */
 - (void)fetchedNewArticleListWithIndex:(NSInteger)index
                                    uid:(NSString *)uid
                            articleType:(ArticleType)articleType
                                  tabid:(NSInteger)tabid
                           conditionDic:(NSDictionary *)conditionDic
                               callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取文章详细信息
 */
- (void)fetchedArticleContentWithAtid:(NSString *)atid uid:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取文章是否喜欢
 */
- (void)fetchedArticleLikeStatusWithAtid:(NSString *)atid uid:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 设置文章为喜欢的
 */
- (void)setArticleToLikeWithLikeStatus:(BOOL)likeStatus atid:(NSString *)atid uid:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 文章喜欢未读数
 */
- (void)fetchedLikeNotReviewCount:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 创建专题/连载
 */
- (void)createTopicOrSerialTabWithUid:(NSString *)uid
                                 type:(ArticleType)type
                                title:(NSString *)title
                          description:(NSString *)description
                                  pic:(NSString *)pic
                              allBack:(dataCallBackBlock)callBack;


/*
 * @brief 按热度获取推荐文章(普通/专题/连载)列表
 */
- (void)fetchedRecommendByHotArticleListtWithIndex:(NSInteger)index uid:(NSString *)uid articleType:(ArticleType)articleType fouseType:(FouseType)fouseType callBack:(dataCallBackBlock)callBack;


/*
 * @brief 按基于用户推荐算法获取推荐文章(普通/专题/连载)列表
 */
- (void)fetchedRecommendByUserCFArticleListtWithIndex:(NSInteger)index uid:(NSString *)uid articleType:(ArticleType)articleType callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取用户对某专题/连载的关注状态
 */
- (void)fetchedTabLikeStatusWithTabid:(NSInteger)tabid uid:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 设置某个专题/连载为关注
 */
- (void)setArticleTabWithLikeStatus:(BOOL)likeStatus tabid:(NSInteger)tabid uid:(NSString *)uid articleType:(ArticleType)articleType callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取喜欢的文章列表
 */
- (void)fetchedUserLikeArticleListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 评论文章
 */
- (void)commentArticleWithAtid:(NSString *)atid fromUid:(NSString *)fromUid toUid:(NSString *)toUid message:(NSString *)message callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取评论列表
 */
- (void)fetchedArticleCommentListWithAtid:(NSString *)atid index:(NSInteger)index allBack:(dataCallBackBlock)callBack;

/*
 * @brief 评论回复
 */
- (void)commmentUserWithAtid:(NSString *)atid cid:(NSInteger)cid fromeUid:(NSString *)fromUid toUid:(NSString *)toUid message:(NSString *)message commentId:(NSInteger)commentId callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取评论回复列表
 */
- (void)fetchedUserCommentToUserListWithCid:(NSInteger)cid index:(NSInteger)index allBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取某两个人评论回复列表
 */
- (void)fetchedUserCommentToUserListWithCid:(NSInteger)cid fromeUid:(NSString *)fromUid toUid:(NSString *)toUid tid:(NSInteger)tid commentId:(NSInteger)commentId commentType:(NSInteger)commentType allBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取针对cid的一条文章评论
 */
- (void)fetchedArticleCommentByCid:(NSInteger)cid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取评论未读数
 */
- (void)fetchedCommentNotReviewCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 设置评论查看状态
 */
- (void)setCommentReviewStatusWithId:(NSInteger)tid commentType:(NSInteger)commentType callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取收到评论文章/评论回复列表
 */
- (void)fetchedReceiveCommentListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取收到用户喜欢自己文章列表
 */
- (void)fetchedReceiveUserLikeArticleListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取用户写的文章个数
 */
- (void)fetchedUserCreateArticleCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBack;
/*
 * @brief 获取推荐文章(普通/专题/连载)列表
 */
- (void)fetchedRecommendArticleListtWithIndex:(NSInteger)index articleType:(ArticleType)articleType fouseType:(FouseType)fouseType;

/*
 * @brief 获取推荐文章(普通/专题/连载)列表, tabid
 */
- (void)fetchedRecommendArticleListtWithIndex:(NSInteger)index articleType:(ArticleType)articleType tabid:(NSInteger)tabid fouseType:(FouseType)fouseType;



@end
