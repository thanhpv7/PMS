package vn.auto.common;

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.InputEvent;

public class MyRobot {

    /**
     * Left mouse click on the point (x, y) in screen
     * 
     * @author phamvanthanh
     * @param x
     * @param y
     * @throws AWTException
     */
    public static void click(int x, int y) throws AWTException {
        Robot bot = new Robot();
        bot.mouseMove(x, y);
        bot.mousePress(InputEvent.BUTTON1_MASK);
        bot.mouseRelease(InputEvent.BUTTON1_MASK);
    }

    /**
     * Left mouse click on google translate button on chrome
     * to translate page from English to Vietnamese
     * 
     * @param width
     * @throws AWTException
     * @throws InterruptedException
     */
    public static void clickGoogleTranslate(int width) throws AWTException, InterruptedException {
        System.out.println("Click google translate button");
        click(width - 200, 5);
        click(width - 120, 50);
        click(width - 270, 120);
        Thread.sleep(2 * 1000);
        click(width - 200, 5);
        waitInSeconds(2);
    }
    
    /**
     * waiting in seconds
     * 
     * @author phamvanthanh
     * @param seconds
     */
    public static void waitInSeconds(int seconds) {
        try {
            Thread.sleep(seconds * 1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
