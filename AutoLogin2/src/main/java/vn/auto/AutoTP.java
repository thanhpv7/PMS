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
import vn.auto.common.Tag;

import com.detectlanguage.errors.APIError;

public class AutoTP {
    private WebDriver driver;
    private final String path = "E:\\SleniumBE\\tutorialspoint\\";
    private final String SCROLL_WEB = "$('html, body').animate({scrollTop: $('#textemail').offset().top}, {_scrollMiliSeconds});";
    private final String MENU_BAR = ".//aside[@class='sidebar']";
    private final String LIST_LINKS = "//li/a";
    private final String CSS_LINK = "http://vietjack.com/cplusplus/";
    private final String NEXT_PAGE = "NEXT PAGE";
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
        AutoTP autoTP = new AutoTP();
        autoTP.run();
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
            List<String> listLinks = MyUtils.getListLinks(menu, By.xpath(LIST_LINKS), CSS_LINK);
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
        // MyRobot.waitInSeconds(2);
        // MyRobot.clickGoogleTranslate(dimension.getWidth());
        // check to ensure page is translated
        for (int i = 0; i < 5; i++) {
            By byNextPage = By.xpath(".//div[@class='content']/div//div[@class='nxt-btn'][1]");
            WebElement nextPageElement = driver.findElement(byNextPage);
            if (nextPageElement.isDisplayed()) {
                if (NEXT_PAGE.equals(nextPageElement.getText().trim().toUpperCase())) {
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
        // int scrollMiliSeconds;
        // JavascriptExecutor jse = ((JavascriptExecutor) driver);
        // long pageHeight = (Long) jse.executeScript(HEIGHT_JQ);
        // scrollMiliSeconds = (int) (pageHeight / dimension.getHeight());
        // jse.executeScript(SCROLL_WEB.replace("{_scrollMiliSeconds}", String.valueOf(scrollMiliSeconds * 2 * 1000)));
        // MyRobot.waitInSeconds(scrollMiliSeconds * 2);

        // get content
        WebElement contentElement = driver.findElement(By.xpath(".//div[@class='content']/div"));
        String innerHTML = contentElement.getAttribute("innerHTML");

        // TODO:
        // convert
        // remove top google lead
        WebElement topGoogleLeadElement = MyUtils.findElement(contentElement, By.xpath("//div[@class='topgooglead']"));
        if (topGoogleLeadElement != null) {
            String test = topGoogleLeadElement.getAttribute("innerHTML");
            innerHTML = innerHTML.replace(test, "");
            innerHTML = innerHTML.replace("<div class=\"topgooglead\"></div>", "");
        }
        // change pre_btn
        List<WebElement> preBtnElements = MyUtils.findElements(contentElement, By.xpath("//div[@class='pre-btn']"));
        if (preBtnElements != null) {
            for (WebElement webElement : preBtnElements) {
                String test = webElement.getAttribute("innerHTML");
                innerHTML = innerHTML.replace(test, "");
                innerHTML = innerHTML.replace("<div class=\"pre-btn\"></div>", Constants.PREVIOUS_PAGE);
            }
        }
        // change nxt_btn
        List<WebElement> nxtBtnElements = MyUtils.findElements(contentElement, By.xpath("//div[@class='nxt-btn']"));
        if (nxtBtnElements != null) {
            for (WebElement webElement : nxtBtnElements) {
                String test = webElement.getAttribute("innerHTML");
                innerHTML = innerHTML.replace(test, "");
                innerHTML = innerHTML.replace("<div class=\"nxt-btn\"></div>", Constants.NEXT_PAGE);
            }
        }
        // remove bottom google lead
        WebElement bottomGoogleLeadElement = MyUtils.findElement(contentElement,
                By.xpath("//div[@class='bottomgooglead']"));
        if (bottomGoogleLeadElement != null) {
            String test = bottomGoogleLeadElement.getAttribute("innerHTML");
            innerHTML = innerHTML.replace(test, "");
            innerHTML = innerHTML.replace("<div class=\"bottomgooglead\"></div>", "");
            innerHTML = innerHTML.replace("<!-- PRINTING ENDS HERE -->", "");
        }
        // remove <div class="print-btn center"> </div>
        WebElement printBtnElement = MyUtils.findElement(contentElement, By.xpath("//div[@class='print-btn center']"));
        if (printBtnElement != null) {
            String test = printBtnElement.getAttribute("innerHTML");
            innerHTML = innerHTML.replace(test, "");
            innerHTML = innerHTML.replace("<div class=\"print-btn center\"></div>", "");
        }
        // remove <div class="pdf-btn">
        WebElement pdfBtnElement = MyUtils.findElement(contentElement, By.xpath("//div[@class='pdf-btn']"));
        if (pdfBtnElement != null) {
            String test = pdfBtnElement.getAttribute("innerHTML");
            innerHTML = innerHTML.replace(test, "");
            innerHTML = innerHTML.replace("<div class=\"pdf-btn\"></div>", "");
        }
        // replace code <pre class="prettyprint notranslate
        // prettyprinted"></pre>
        // List<WebElement> codeElements = MyUtils.findElements(contentElement,
        // By.xpath("//pre[@class='prettyprint notranslate prettyprinted']"));
        // if (codeElements != null) {
        // for (WebElement webElement : codeElements) {
        // String test = webElement.getAttribute("innerHTML");
        // String tpCode = webElement.getText();
        // String vtCode = Constants.CSS_CODE.replace("{code}", tpCode);
        // innerHTML = innerHTML.replace(test, "");
        // innerHTML = innerHTML.replace("<pre class=\"prettyprint notranslate
        // prettyprinted\"></pre>", vtCode);
        // }
        // }
        // replace code <pre class="prettyprint notranslate tryit
        // prettyprinted"></pre>
        List<WebElement> codeElements = MyUtils.findElements(contentElement,
                By.xpath("//pre[contains(@class,'prettyprint')]"));
        if (codeElements != null) {
            for (WebElement webElement : codeElements) {
                String test = webElement.getAttribute("innerHTML");
                String tpCode = webElement.getText();
                String vtCode = Constants.CSS_CODE_TP.replace("{code}", tpCode);
                // innerHTML = MyUtils.convertCode(innerHTML, "<pre
                // class=\"prettyprint", "</pre>", vtCode);
                Tag tag = MyUtils.findTag(new StringBuilder(innerHTML), "<pre class=\"prettyprint", "<pre", "</pre>");
                if (tag != null) {
                    test = innerHTML.substring(tag.getOpenTagPos(), tag.getEndTagPos());
                    innerHTML = innerHTML.replace(test, vtCode);
                } else {
                    // innerHTML = innerHTML.replace(test, "");
                    // innerHTML = innerHTML.replace("<pre class=\"prettyprint
                    // notranslate tryit prettyprinted\"></pre>", vtCode);
                }
            }
        }
        // replace result <pre class="result notranslate"></pre>
        List<WebElement> codeResultElements = MyUtils.findElements(contentElement,
                By.xpath("//pre[contains(@class,'result')]"));
        if (codeResultElements != null) {
            for (WebElement webElement : codeResultElements) {
                String test = webElement.getAttribute("innerHTML");
                String tpCodeResult = webElement.getText();
                String vtCodeResult = Constants.CSS_CODE_RESULT_TP.replace("{code_result}", tpCodeResult);
                // innerHTML = innerHTML.replace(test, "");
                // innerHTML = innerHTML.replace("<pre class=\"result
                // notranslate\"></pre>", vtCodeResult);

                // innerHTML = MyUtils.convertCode(innerHTML, "<pre
                // class=\"result", "</pre>", vtCodeResult);
                Tag tag = MyUtils.findTag(new StringBuilder(innerHTML), "<pre class=\"result", "<pre", "</pre>");
                if (tag != null) {
                    test = innerHTML.substring(tag.getOpenTagPos(), tag.getEndTagPos());
                    innerHTML = innerHTML.replace(test, vtCodeResult);
                } else {
                    innerHTML = innerHTML.replace(test, "");
                    innerHTML = innerHTML.replace("<pre class=\"prettyprint notranslate tryit prettyprinted\"></pre>",
                            vtCodeResult);
                }

            }
        }
        // replace class of table class="table table-bordered" to class="alt"
        innerHTML = innerHTML.replace("<table class=\"table table-bordered\">", "<table class=\"alt\">");
        // replace font tag
        innerHTML = innerHTML.replace("<font>", "").replace("</font>", "");
        // replace double break line symbol
        innerHTML = innerHTML.replace("\n\n", "");

        //
        innerHTML = innerHTML.replace(" -<", ":<");
        innerHTML = innerHTML.replace("hồ sơ", "bản ghi");
        innerHTML = innerHTML.replace("KHÁCH HÀNG", "CUSTOMERS");
        innerHTML = innerHTML.replace("Thí dụ", "Ví dụ");
        innerHTML = innerHTML.replace("tìm nạp", "lấy ra");
        innerHTML = innerHTML.replace("SQL> ", "");

        // format html
        // innerHTML = MyUtils.formatHTML(driver, innerHTML);

        // create fileName
        String prefix_name = num < 10 ? "0" + num : "" + num;
        String fileName = path + Constants.CPLUSPLUS_FOLDER + prefix_name + "-"
                + url.substring(CSS_LINK.length(), url.length());
        fileName = fileName.replace("/", "\\").replace("_", "-");
        // write content to file
        MyUtils.writeHTML(fileName, innerHTML);
    }
}
