package com.g06.springboot.service;

import com.g06.springboot.SpringbootApplication;
import com.g06.springboot.entity.Song;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 *@Description SongService 单元测试类
 *@Author ZSY
 *@Date 2020/12/28 20:05
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = SpringbootApplication.class)
public class SongServiceTest {
	@Autowired
	private SongService songService;

	@Test
	public void getAddSong(){
		songService.addSong(4,"1234","网易云");
	}

	@Test
	public void getCheckSong(){
		Song song = songService.checkSong(4, "1234", "网易云");
		Assert.assertEquals("添加歌单错误",4,song.getSongListId());
		Assert.assertEquals("添加歌曲错误","1234",song.getSongId());

		Song song1 = songService.checkSong(1,"1234","网易云");
		Assert.assertNull("歌单确认失败",song1);
	}

	@Test
	public void getRemoveSong(){
		songService.removeSong(4,"1234");
	}

}
