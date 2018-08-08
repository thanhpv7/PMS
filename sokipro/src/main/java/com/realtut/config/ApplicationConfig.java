package com.realtut.config;

import java.io.IOException;
import java.util.Properties;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.hibernate4.HibernateTransactionManager;
import org.springframework.orm.hibernate4.LocalSessionFactoryBean;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import com.realtut.dao.UserDaoImpl;

@EnableWebMvc
@Configuration
@ComponentScan(basePackages = { "com.realtut" })
@PropertySource("classpath:application.properties")
public class ApplicationConfig {

    @Autowired
    Environment evn;

    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setViewClass(JstlView.class);
        viewResolver.setPrefix("/WEB-INF/view/");
        viewResolver.setSuffix(".jsp");
        return viewResolver;
    }

    @Bean
    public DriverManagerDataSource dataSource() throws IOException {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(evn.getProperty("jdbc.driverClassName"));
        dataSource.setUrl(evn.getProperty("jdbc.url"));
        dataSource.setUsername(evn.getProperty("jdbc.username"));
        dataSource.setPassword(evn.getProperty("jdbc.password"));
        return dataSource;
    }

    @Bean
    public LocalSessionFactoryBean sessionFactory() throws IOException {
        LocalSessionFactoryBean sessionFactory = new LocalSessionFactoryBean();
        sessionFactory.setDataSource(dataSource());
        sessionFactory.setPackagesToScan(new String[] { "com.realtut.model" });
        sessionFactory.setHibernateProperties(hibernateProperties());
        return sessionFactory;
    }

    @Bean
    @Autowired
    public HibernateTransactionManager transactionManager(SessionFactory sessionFactory) {
        HibernateTransactionManager txManager = new HibernateTransactionManager();
        txManager.setSessionFactory(sessionFactory);
        return txManager;
    }

    @Bean
    @Autowired
    public UserDaoImpl userDao(SessionFactory sessionFactory) {
        UserDaoImpl userDao = new UserDaoImpl();
        userDao.setSessionFactory(sessionFactory);
        return userDao;
    }

    Properties hibernateProperties() {
        return new Properties() {
            {
                setProperty("hibernate.dialect", evn.getProperty("hibernate.dialect"));
                setProperty("hibernate.format_sql", evn.getProperty("hibernate.format_sql"));
                setProperty("hibernate.show_sql", evn.getProperty("hibernate.show_sql"));
            }
        };
    }
}
