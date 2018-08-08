package com.realtut.ws;

import java.util.List;



public interface UsersService {
	
	Users findById(long id);
	
	Users findByName(String name);
	
	void saveUser(Users user);
	
	void updateUser(Users user);
	
	void deleteUserById(long id);

	List<Users> findAllUsers(); 
	
	void deleteAllUsers();
	
	public boolean isUserExist(Users user);
	
}
