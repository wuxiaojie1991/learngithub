setwd("/home/ftpusers/ftpbxcrm/bxin/800app/")
source("/home/chenxuyuan/.Rprofile")
source("/home/chenxuyuan/myfunction.R")

file_name<- function(){
  shift_hour<-function(t){ #把shift_hour函数写进来了。目的是取最近一次的文件
    if (substr(t,9,10)=="00"){
      temp <- format(Sys.time(),format = "%Y-%m-%d")
      temp <- as.Date(temp)
      temp<-temp-1
      temp<-format(temp,format = "%Y%m%d")
      t<-paste(temp,"23",sep="")
    }else{
      t<-as.numeric(t)
      t<-t-1
      t<-as.character(t)
    }
    return(t)
  }
  setwd("/home/ftpusers/ftpbxcrm/bxin/800app/")
  t = Sys.time()
  t = format(t,format = "%Y%m%d%H")
  get_title = paste(t,".csv",sep="")
  while (file.exists(get_title)==FALSE){
    t = shift_hour(t)
    get_title = paste(t,".csv",sep="")
  }
  return (get_title)
}

b<-read.csv(file_name(),stringsAsFactors=F)
info<-b[c("客户id","用户编号")]
#info$客户id<-as.numeric(as.character(info$客户id))
#info$用户编号<-as.numeric(as.character(info$用户编号))
info_last<-subset(info,!is.na("用户编号"))
colnames(info_last)<-c("crm_id","user_id")
info_last$crm_id=as.integer(info_last$crm_id)
info_last$user_id=as.integer(info_last$user_id)

dbRemoveTable(connDW,"pgtemp.userid_bianhao")
dbWriteTable(connDW,"pgtemp.userid_bianhao",value=info_last)
mysendmail(wd=NA,subject="uid_kehuid_relation_input_success",files=NA,to=c("<chenxuyuan@baixing.com>"))

