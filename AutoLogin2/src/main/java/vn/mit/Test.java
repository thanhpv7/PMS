package vn.mit;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import vn.auto.common.MyUtils;

public class Test {
    public static void main(String[] args) {
        WebDriver driver = MyUtils.openChrome();
        driver.get("http://localhost:8080/mms/login.do");
        // login
        WebElement weUsername = driver.findElement(By.xpath(".//input[@name='userId']"));
        WebElement wePassword = driver.findElement(By.xpath(".//input[@name='password']"));
        WebElement weLogin = driver.findElement(By.xpath(".//input[@name='login']"));
        weUsername.sendKeys("all");
        wePassword.sendKeys("password");
        weLogin.click();
        // go to registration
        WebElement iFrame= driver.findElement(By.tagName("frameset"));
        driver.switchTo().frame("menuFrame");
        WebElement weMMSMenu = driver.findElement(By.id("tdmainMenum_0"));
        weMMSMenu.click();
        WebElement weRegMenu = driver.findElement(By.id("tdmainMenum_0_22"));
        weRegMenu.click();
        
    }
}