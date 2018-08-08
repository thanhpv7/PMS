package com.realtut.dao;

import com.realtut.model.Users;

public interface UserDao {
	public Users findByUserName(String username);
}
