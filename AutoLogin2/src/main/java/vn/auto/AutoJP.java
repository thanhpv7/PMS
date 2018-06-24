package vn.auto;

import java.awt.AWTException;
import java.io.IOException;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import vn.auto.common.Constants;
import vn.auto.common.MyRobot;
import vn.auto.common.MyUtils;

import com.detectlanguage.errors.APIError;

public class AutoJP {
    private WebDriver driver;
    private final String path = "E:\\SleniumBE\\javatpoint\\";
    private final String SCROLL_WEB = "$('html, body').animate({scrollTop: $('#footer').offset().top}, {_scrollMiliSeconds});";
    private final String MENU_BAR = ".//div[@id='menu']";
    private final String LIST_LINKS = "//div[@class=\"leftmenu\"]//a";
    private final String HOME_PAGE = "https://www.javatpoint.com";
    private final String CSS_LINK = "https://www.javatpoint.com/css-tutorial";
    private final String NEXT_PAGE = "next";
    private Dimension dimension;
    private String HEIGHT_JQ = "return $(document ).height();";

    /**
     * main method
     * 
     * @param args
     */
    public static void main(String[] args) {
        System.out.println("START");
        Long startTime = System.currentTimeMillis();
        AutoJP autoJP = new AutoJP();
        autoJP.run();
        Long endTime = System.currentTimeMillis();
        System.out.println("Time: " + ((endTime - startTime) / 1000 / 60) + "minutes");
        System.out.println("END");
    }

    /**
     * run app
     * 
     * @author phamvanthanh
     */
    public void run() {
        try {
            // open chrome browser
            driver = MyUtils.openChrome();
            // maximize browser
            driver.manage().window().maximize();
            // get dimension (height and width) of screen
            dimension = driver.manage().window().getSize();
            // go to index page of the topic
            driver.get(CSS_LINK);
            // get list links from menu
            WebElement menu = driver.findElement(By.xpath(MENU_BAR));
            List<String> listLinks = MyUtils.getListLinks(menu, By.xpath(LIST_LINKS), HOME_PAGE);
            // get content of list links
            if (listLinks != null && listLinks.size() > 0) {
                int listLinksSize = listLinks.size();
                for (int i = 0; i < listLinksSize; i++) {
                    convertContent(listLinks.get(i), path, i);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (driver != null) {
                driver.quit();
            }
        }
    }

    /**
     * convert web content
     * 
     * @param url
     * @return converted content
     * @throws InterruptedException
     * @throws IOException
     * @throws AWTException
     * @throws APIError
     */
    private void convertContent(String url, String path, int num)
            throws InterruptedException, IOException, AWTException, APIError {
        boolean isTranslated = false;
        // open url
        System.out.println("Open url = " + url);
        driver.get(url);
        MyRobot.waitInSeconds(2);
        MyRobot.clickGoogleTranslate(dimension.getWidth());
        // check to ensure page is translated
        for (int i = 0; i < 5; i++) {
            By byNextPage = By.xpath(".//*[@id='bottomnextup']/a[1]");
            WebElement nextPageElement = driver.findElement(byNextPage);
            if (nextPageElement.isDisplayed()) {
                if (nextPageElement.getText().trim().toUpperCase().contains(NEXT_PAGE)) {
                    MyRobot.clickGoogleTranslate(dimension.getWidth());
                } else {
                    isTranslated = true;
                    break;
                }
            } else {
                MyRobot.waitInSeconds(2);
            }
        }
        // print page is translated?
        System.out.println("is translated: " + isTranslated);
        // scroll down
        int scrollMiliSeconds;
        MyUtils.injectJQuery(driver);
        JavascriptExecutor jse = ((JavascriptExecutor) driver);
        long pageHeight = (Long) jse.executeScript(HEIGHT_JQ);
        scrollMiliSeconds = (int) (pageHeight / dimension.getHeight());
        jse.executeScript(SCROLL_WEB.replace("{_scrollMiliSeconds}", String.valueOf(scrollMiliSeconds * 2 * 1000)));
        MyRobot.waitInSeconds(scrollMiliSeconds * 2);

        // get content
        WebElement contentElement = driver.findElement(By.xpath(".//*[@id='city']/table/tbody/tr/td"));
        String innerHTML = contentElement.getAttribute("innerHTML");
        
        // TODO: convert page content
        

        // replace font tag
        innerHTML = innerHTML.replace("<font>", "").replace("</font>", "");
        // replace double break line symbol
        innerHTML = innerHTML.replace("\n\n", "");

        // create fileName
        String prefix_name = num < 10 ? "0" + num : "" + num;
        String fileName = path + Constants.CSS_FOLDER + prefix_name + "-"
                + url.substring(HOME_PAGE.length() + 1, url.length()) + ".html";
        fileName = fileName.replace("/", "\\").replace("_", "-");
        // write content to file
        MyUtils.writeHTML(fileName, innerHTML);
    }
}
