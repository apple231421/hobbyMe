package util;

import java.io.IOException;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeUtility;

public class MailUtil {

    public static void send(String toEmail, String subject, String content) throws IOException {
    	Properties config = new Properties();
    	config.load(MailUtil.class.getClassLoader().getResourceAsStream("config.properties"));
    	final String fromEmail = config.getProperty("mail.fromEmail");
    	final String password = config.getProperty("mail.password");


        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587");              
        props.put("mail.smtp.auth", "true");             
        props.put("mail.smtp.starttls.enable", "true");  

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, MimeUtility.encodeText("HobbyMe 관리자", "UTF-8", "B")));
            message.setRecipients(
                    Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("이메일 전송 성공");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("이메일 전송 실패");
        }
    }
}
