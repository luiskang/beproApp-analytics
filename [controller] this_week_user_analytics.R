tw_userid_list = as.data.frame(table(tw_event_table$user_id))
lw_userid_list = as.data.frame(table(lw_event_table$user_id))

names(tw_userid_list) = names(lw_userid_list) = c('user_id', 'freq')

tw_userid_list$week = 'tw'
lw_userid_list$week = 'lw'

week_userid_list = rbind(tw_userid_list, lw_userid_list)
week_userid_list = week_userid_list[, -2]
week_userid_list[order(week_userid_list$user_id), ]

dupRows = dupsBetweenGroups(week_userid_list, 'week')
week_userid_list = cbind(week_userid_list, dup = dupRows)
week_userid_list[order(week_userid_list$user_id), ]

tw_userid_list = subset(week_userid_list, week=='tw', select = -week)
lw_userid_list = subset(week_userid_list, week=='lw', select = -week)

#지난주 방문 유저 중 재방문률
round(nrow(lw_userid_list[lw_userid_list$dup==TRUE,]) / nrow(lw_userid_list)* 100, 2)

#이번주 유저 유형 분포 (유지 / 복귀 / 신규)
tw_retention = subset(tw_userid_list, dup==TRUE)
tw_not_retention = subset(tw_userid_list, dup==FALSE)

merge_day_retention = merge(x = tw_not_retention, y = valid_user, by.x = 'user_id', by.y = 'id')
merge_day_retention = merge_day_retention[order(merge_day_retention$created_day),]

tw_new_user = merge_day_retention[merge_day_retention$created_day %in% tw_date,]
tw_new_user_rate = round((nrow(tw_new_user) / nrow(tw_userid_list)) * 100, 2)
tw_retention_rate = round(nrow(tw_retention) / nrow(tw_userid_list) * 100, 2)
tw_return_rate = round((nrow(tw_not_retention)-nrow(tw_new_user)) / nrow(tw_userid_list) *100, 2)

tw_new_user_rate
tw_retention_rate
tw_return_rate

