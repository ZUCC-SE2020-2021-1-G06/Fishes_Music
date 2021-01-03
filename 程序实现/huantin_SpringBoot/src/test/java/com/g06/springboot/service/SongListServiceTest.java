package com.g06.springboot.service;

import com.g06.springboot.SpringbootApplication;
import com.g06.springboot.entity.SongList;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 *@Description SongListService 的单元测试类
 *@Author ZSY
 *@Date 2020/12/28 16:33
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = SpringbootApplication.class)
public class SongListServiceTest {
	@Autowired
	private SongListService songListService;

	@Test
	public void getAddList(){
		songListService.addList(1,"测试歌单2","这是一个测试歌单");
	}

	@Test
	public void getCheckList(){
		SongList songList = songListService.checkList(1, "测试歌单1");
		Assert.assertEquals("歌单所属用户错误",1,songList.getUserId());
		Assert.assertEquals("歌单名错误","测试歌单1",songList.getSongListName());

		SongList songList1 = songListService.checkList(2,"测试歌单1");
		Assert.assertNull("歌单确认失败",songList1);
	}

	@Test
	public void getRemoveList(){
		songListService.removeList(1,"测试歌单2");
	}

	@Test
	public void getModifyList(){
		songListService.modifyList(1,"测试歌单1","测试修改","https://images.pexels.com/photos/4319752/pexels-photo-4319752.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500");
	}




}
