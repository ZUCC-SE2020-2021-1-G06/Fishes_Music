/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2020/11/19 0:39:24                           */
/*==============================================================*/


drop table if exists MusicList;

drop table if exists MusicListInfo;

drop table if exists MusicListOnline;

drop table if exists MusicListOnlineInfo;

drop table if exists MusicOrder;

drop table if exists MusicOrderOnlineInfo;

drop table if exists OutUser;

drop table if exists User;

/*==============================================================*/
/* Table: MusicList                                             */
/*==============================================================*/
create table MusicList
(
   UserId               char,
   MusicListId          char not null,
   MusicListName        char,
   primary key (MusicListId)
);

/*==============================================================*/
/* Table: MusicListInfo                                         */
/*==============================================================*/
create table MusicListInfo
(
   MusicListId          char,
   MusicId              char not null,
   MusicName            char,
   MusicInfo            char(10),
   primary key (MusicId)
);

/*==============================================================*/
/* Table: MusicListOnline                                       */
/*==============================================================*/
create table MusicListOnline
(
   OutUser              char(10),
   MusicListId          char not null,
   MusicListName        char,
   primary key (MusicListId)
);

/*==============================================================*/
/* Table: MusicListOnlineInfo                                   */
/*==============================================================*/
create table MusicListOnlineInfo
(
   MusicListId          char,
   MusicId              char not null,
   MusicName            char,
   MusicInfo            char(10),
   primary key (MusicId)
);

/*==============================================================*/
/* Table: MusicOrder                                            */
/*==============================================================*/
create table MusicOrder
(
   OutUser              char(10),
   MusicOrderId         char not null,
   MusicOrderName       char,
   primary key (MusicOrderId)
);

/*==============================================================*/
/* Table: MusicOrderOnlineInfo                                  */
/*==============================================================*/
create table MusicOrderOnlineInfo
(
   MusicOrder           int,
   MusicId              char not null,
   MusicOrderId         char,
   MusicName            char,
   MusicInfo            char(10),
   primary key (MusicId)
);

/*==============================================================*/
/* Table: OutUser                                               */
/*==============================================================*/
create table OutUser
(
   OutUser              char(10) not null,
   VIP                  boolean,
   UserId               char,
   primary key (OutUser)
);

/*==============================================================*/
/* Table: User                                                  */
/*==============================================================*/
create table User
(
   Name                 char,
   Image                char(10),
   UserId               char not null,
   Password             char,
   Zhanghao             char,
   primary key (UserId)
);

alter table MusicList add constraint FK_Reference_1 foreign key (UserId)
      references User (UserId) on delete restrict on update restrict;

alter table MusicListInfo add constraint FK_Reference_2 foreign key (MusicListId)
      references MusicList (MusicListId) on delete restrict on update restrict;

alter table MusicListOnline add constraint FK_Reference_4 foreign key (OutUser)
      references OutUser (OutUser) on delete restrict on update restrict;

alter table MusicListOnlineInfo add constraint FK_Reference_5 foreign key (MusicListId)
      references MusicListOnline (MusicListId) on delete restrict on update restrict;

alter table MusicOrder add constraint FK_Reference_6 foreign key (OutUser)
      references OutUser (OutUser) on delete restrict on update restrict;

alter table MusicOrderOnlineInfo add constraint FK_Reference_7 foreign key (MusicOrderId)
      references MusicOrder (MusicOrderId) on delete restrict on update restrict;

alter table OutUser add constraint FK_Reference_3 foreign key (UserId)
      references User (UserId) on delete restrict on update restrict;

