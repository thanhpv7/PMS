package com.realtut.ws;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("usersService")
@Transactional
public class UsersServiceImpl implements UsersService{
	
	private static final AtomicLong counter = new AtomicLong();
	
	private static List<Users> users;
	
	static{
		users= populateDummyUsers();
	}

	public List<Users> findAllUsers() {
		return users;
	}
	
	public Users findById(long id) {
		for(Users user : users){
			if(user.getId() == id){
				return user;
			}
		}
		return null;
	}
	
	public Users findByName(String name) {
		for(Users user : users){
			if(user.getName().equalsIgnoreCase(name)){
				return user;
			}
		}
		return null;
	}
	
	public void saveUser(Users user) {
		user.setId(counter.incrementAndGet());
		users.add(user);
	}

	public void updateUser(Users user) {
		int index = users.indexOf(user);
		users.set(index, user);
	}

	public void deleteUserById(long id) {
		
		for (Iterator<Users> iterator = users.iterator(); iterator.hasNext(); ) {
		    Users user = iterator.next();
		    if (user.getId() == id) {
		        iterator.remove();
		    }
		}
	}

	public boolean isUserExist(Users user) {
		return findByName(user.getName())!=null;
	}

	private static List<Users> populateDummyUsers(){
		List<Users> users = new ArrayList<Users>();
		users.add(new Users(counter.incrementAndGet(),"Sam",30, 70000));
		users.add(new Users(counter.incrementAndGet(),"Tom",40, 50000));
		users.add(new Users(counter.incrementAndGet(),"Jerome",45, 30000));
		users.add(new Users(counter.incrementAndGet(),"Silvia",50, 40000));
		return users;
	}

	public void deleteAllUsers() {
		users.clear();
	}

}
