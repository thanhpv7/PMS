package vn.auto.common;

import java.awt.AWTException;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;

public class MyUtils {

    /**
     * open chrome browser
     * 
     * @author phamvanthanh
     * @throws InterruptedException
     * @throws AWTException
     */
    public static WebDriver openChrome() {
        System.setProperty("webdriver.chrome.driver", "E:\\SleniumBE\\chromedriver3_32.exe");
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--user-data-dir=E:\\SleniumBE\\BrowserProfile");
        return new ChromeDriver(options);
    }
    
    /**
     * open chrome browser
     * 
     * @author phamvanthanh
     * @throws InterruptedException
     * @throws AWTException
     */
    public static WebDriver openFirefox() {
        System.setProperty("webdriver.gecko.driver", "E:\\SleniumBE\\geckodriver.exe");
        return new FirefoxDriver();
    }

    /**
     * find element with handling exception
     * 
     * @author phamvanthanh
     * @param parent
     * @param by
     * @return WebElement
     */
    public static WebElement findElement(WebElement parent, By by) {
        try {
            return parent.findElement(by);
        } catch (Exception ex) {
            ex.getMessage();
        }
        return null;
    }

    /**
     * find elements with handling exception
     * 
     * @author phamvanthanh
     * @param parent
     * @param by
     * @return List<WebElement>
     */
    public static List<WebElement> findElements(WebElement parent, By by) {
        try {
            return parent.findElements(by);
        } catch (Exception ex) {
            ex.getMessage();
        }
        return null;
    }

    /**
     * get list links
     * 
     * @author phamvanthanh
     * @return
     */
    public static List<String> getListLinks(WebElement menu, By byListLinks, String prefixLink) {
        List<String> listLinks = new ArrayList<String>();
        List<WebElement> listElementLinks = menu.findElements(byListLinks);

        for (WebElement element : listElementLinks) {
            String link = element.getAttribute("href");
            if (link.contains(prefixLink)) {
                listLinks.add(link);
            }
        }
        return listLinks;
    }

    /**
     * write text to file with UTF-8 encoding
     * 
     * @author phamvanthanh
     * @param fileName
     * @param content
     * @throws IOException
     */
    public static void writeHTML(String fileName, String content) throws IOException {
        FileOutputStream fos = null;
        OutputStreamWriter osw = null;
        BufferedWriter bw = null;

        try {
            fos = new FileOutputStream(fileName);
            osw = new OutputStreamWriter(fos, "UTF-8");
            bw = new BufferedWriter(osw);
            bw.write(content);
        } catch (IOException ex) {
            ex.printStackTrace();
        } finally {
            if (bw != null)
                bw.close();
            if (osw != null)
                osw.close();
            if (fos != null)
                fos.close();
        }
    }

    /**
     * read file
     * 
     * @author phamvanthanh
     * @param file
     * @return
     * @throws IOException
     */
    public static String readFile(String file) throws IOException {
        Charset cs = Charset.forName("UTF-8");
        FileInputStream stream = new FileInputStream(file);
        try {
            Reader reader = new BufferedReader(new InputStreamReader(stream, cs));
            StringBuilder builder = new StringBuilder();
            char[] buffer = new char[8192];
            int read;
            while ((read = reader.read(buffer, 0, buffer.length)) > 0) {
                builder.append(buffer, 0, read);
            }
            return builder.toString();
        } finally {
            stream.close();
        }
    }

    /**
     * inject jQuery to page
     * 
     * @throws IOException
     */
    public static void injectJQuery(WebDriver driver) throws IOException {
        String jQueryLoader = MyUtils.readFile("jQuerify.txt");
        driver.manage().timeouts().setScriptTimeout(10, TimeUnit.SECONDS);
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeAsyncScript(jQueryLoader);
    }

    /**
     * format html online
     * 
     * @author phamvanthanh
     * @param driver
     * @param htmlContent
     * @return
     */
    public static String formatHTML(WebDriver driver, String htmlContent) {
        try {
            driver.get("https://www.freeformatter.com/html-formatter.html");
            // input
            WebElement htmlAreaElement = driver.findElement(By.xpath(".//*[@id='htmlString']"));
            htmlAreaElement.sendKeys(htmlContent);
            // select indentation
            Select indentationSelect = new Select(driver.findElement(By.xpath(".//*[@id='indentation']")));
            indentationSelect.selectByValue("TWO_SPACES");
            // click [format html] button
            WebElement formatBtn = driver.findElement(By.xpath(".//*[@id='form']/div[4]/button[1]"));
            formatBtn.click();
            // click [copy to clipboard] button
            WebElement copyToClipboardBtn = driver.findElement(By.xpath(".//*[@id='copyToClipboard']"));
            copyToClipboardBtn.click();
            // get text form clipboard
            TextTransfer textTransfer = new TextTransfer();
            String copiedText = textTransfer.getClipboardContents();
            if (!"".equals(copiedText)) {
                htmlContent = copiedText;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return htmlContent;
    }

    /**
     * test convert code
     * 
     * @author phamvanthanh
     */
    public static String convertCode(String text, String start, String end, String sub) {
        int codeTagStartIndex = text.indexOf(start);
        int codeTagEndIndex = text.indexOf(end, codeTagStartIndex);
        String tpCode = text.substring(codeTagStartIndex, codeTagEndIndex + end.length());
        return text.replace(tpCode, sub);
    }

    /**
     * find position of open tag and end tag
     * 
     * 
     * @param text
     * @param openTag
     * @param endTag
     * @param sub
     * @author phamvanthanh
     * @return
     */
    public static Tag findTag(StringBuilder text, String determineTag, String openTag, String endTag) {
        Tag tag = null;

        // index of determine tag
        int openTagIndex = text.indexOf(determineTag);
        // list tags found
        List<String> listStr = new ArrayList<String>();
        listStr.add(openTag);

        if (openTagIndex != -1) {
            // find open tag or end tag nearer than determine tag
            int nextOpenTagIndex = text.indexOf(openTag, openTagIndex + 1);
            int endTagIndex = text.indexOf(endTag, openTagIndex + 1);
            if (nextOpenTagIndex != -1) {
                if (endTagIndex < nextOpenTagIndex) {
                    tag = new Tag(openTagIndex, endTagIndex + endTag.length());
                } else {
                    listStr.add(openTag);
                    int nextTag = nextOpenTagIndex;
                    // find until number of end tag and open tag in listTag are equal 
                    while (true) {
                        int openTagIndex1 = text.indexOf(openTag, nextTag  +1 );
                        int endTagIndex1 = text.indexOf(endTag, nextTag + 1);
                        if (openTagIndex1 != -1) {
                            if (openTagIndex1 < endTagIndex1) {
                                listStr.add(openTag);
                                int openTagIndex2 = text.indexOf(openTag, openTagIndex1 + 1);
                                int endTagIndex2 = text.indexOf(endTag, openTagIndex1 + 1);
                                if (openTagIndex2 != -1) {
                                    if (openTagIndex2 < endTagIndex2) {
                                        listStr.add(openTag);
                                        nextTag = openTagIndex2;
                                    } else {
                                        listStr.add(endTag);
                                        nextTag = endTagIndex2;
                                    }
                                }
                            } else {
                                listStr.add(endTag);
                                int openTagIndex2 = text.indexOf(openTag, endTagIndex1 + 1);
                                int endTagIndex2 = text.indexOf(endTag, endTagIndex1 + 1);
                                if (openTagIndex2 != -1) {
                                    if (openTagIndex2 < endTagIndex2) {
                                        listStr.add(openTag);
                                        nextTag = openTagIndex2;
                                    } else {
                                        listStr.add(endTag);
                                        nextTag = endTagIndex2;
                                    }
                                }
                            }
                        }
                        // Check if number of end tag and open tag in listTag are equal 
                        // --> end tag of determine tag is found
                        int openCount = 0;
                        int endCount = 0;
                        for (String str : listStr) {
                            if (endTag.equals(str)) {
                                endCount++;
                            } else {
                                openCount++;
                            }
                        }
                        if (openCount == endCount) {
                            tag = new Tag(openTagIndex, nextTag + endTag.length());
                            break;
                        }
                    }
                }
            } else {
                tag = new Tag(openTagIndex, endTagIndex + endTag.length());
            }
        }
        return tag;
    }

    /**
     * my test
     * 
     * @author phamvanthanh
     * @param args
     */
    public static void main(String[] args) {
        String innerHTML = "<p> Hello </p> <div> Learn Java </div> <pre class=\"prettyprint notranslate tryit prettyprinted\" style=\"abc def ...\"> vd1 <pre> <pre> sub1 </pre> test <pre> test1 </pre> </pre> </pre>"
                + "<p> Vi du 2: </p> <pre class=\"prettyprint1 notranslate tryit prettyprinted\" style=\"abc def ...\"> vd2 </pre>";
        String vtCode1 = "[code] vt1 = true; [/code]";
        String vtCode2 = "[code] vt2 = true; [/code]";
//        innerHTML = MyUtils.convertCode(innerHTML, "<pre class=\"prettyprint", "</pre>", vtCode1);
//        System.out.println(innerHTML);
//        innerHTML = MyUtils.convertCode(innerHTML, "<pre class=\"prettyprint", "</pre>", vtCode2);
//        System.out.println(innerHTML);
        
        Tag tag = MyUtils.findTag(new StringBuilder(innerHTML), "<pre class=\"prettyprint", "<pre", "</pre>");
        System.out.println(tag.getOpenTagPos() + ", " + tag.getEndTagPos());
        Tag tag1 = MyUtils.findTag(new StringBuilder(innerHTML), "<pre class=\"prettyprint1", "<pre", "</pre>");
        System.out.println(tag1.getOpenTagPos() + ", " + tag1.getEndTagPos());
        System.out.println(innerHTML.substring(tag.getOpenTagPos(), tag.getEndTagPos()));
        System.out.println(innerHTML.substring(tag1.getOpenTagPos(), tag1.getEndTagPos()));
    }
}
