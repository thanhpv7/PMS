package vn.auto.common;

import com.detectlanguage.DetectLanguage;
import com.detectlanguage.errors.APIError;

public class MyDetectLanguage {
    //https://detectlanguage.com/
    private static final String API_KEY = "ffa10d44357fa2cbb79cff7425b7cd2d";

    /**
     * detect language
     * 
     * @param text
     * @return language of text
     * @throws APIError
     */
    public static String detect(String text) throws APIError {
        DetectLanguage.apiKey = API_KEY;
        return DetectLanguage.simpleDetect(text);
    }
}
