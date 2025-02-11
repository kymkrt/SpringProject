package com.spring.javaGroupS2.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;

@Component
public class CommonClass {
	
	@Autowired
	JavaMailSender mailSender;
	
	//파일 넣기
	public void writeFile(MultipartFile fName, String sFileName, String path, String processType) throws IOException {
		System.out.println("파일입력 메소드");
		System.out.println("path : "+path);
		System.out.println("sFileName : "+sFileName);
		System.out.println("fName : "+fName);
		System.out.println("processType : "+processType);
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath(path);
		
		FileOutputStream fos = new FileOutputStream(realPath + sFileName);
		if(fName.getBytes().length != -1) {
			System.out.println("파일쓰는중");
			fos.write(fName.getBytes());
		}

			fos.flush();
			fos.close();
		
	}
	
	//파일 지우기
	public void deleteFile(MultipartFile fName, String sFileName, String path) throws IOException {
		System.out.println("파일삭제 메소드");
		System.out.println("이전 path : "+path);
		System.out.println("이전 sFileName : "+sFileName);
		System.out.println("이전 fName : "+fName);
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath(path);
		
		File oldFile = new File(realPath + sFileName);
		
		if(oldFile.exists()) {
			System.out.println("파일 삭제 확인");
			oldFile.delete();
		}
	}
	
//이메일 처리
	public void mailSend(String toMail, String title, String mailFlag, String value) throws MessagingException {
		String content = "";
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		HttpSession session = request.getSession();
		
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8"); 
			
			messageHelper.setTo(toMail);			// 받는 사람의 메일주소
			messageHelper.setSubject(title);	// 메일 제목
			messageHelper.setText(content);		// 메일 내용
			
			content = content.replace("\n", "<br>"); 
			content += "<br><hr><h2>"+mailFlag+"</h2><hr><br>";
			if(mailFlag.equals("인증번호")) {
			 UUID uuid = UUID.randomUUID();
			 String emailkey = uuid.toString().substring(0, 8);
			 content+= "<h4>인증용 코드</h4><br>";
			 content+= "<h5>"+emailkey+"</h5><br>";
			 content+= "<h5>이 코드를 입력해주세요</h5><br>";
			 session.setAttribute("sEmailkey", emailkey);
			}
			else if(mailFlag.equals("임시비밀번호발급")) {
				String tempPwd = RandomStringUtils.randomAlphanumeric(10);
			 content+= "<h4>임시비밀번호</h4><br>";
			 content+= "<h5>"+tempPwd+"</h5><br>";
			 content+= "<h5>로그인후 비밀번호를 변경해주세요</h5><br>";
			 session.setAttribute("sTempPwd", tempPwd);
			}
			else if(mailFlag.equals("임시비밀번호발급_카카오")) {
				content+= "<h4>임시비밀번호</h4><br>";
				content+= "<h5>"+value+"</h5><br>";
				content+= "<h5>로그인후 비밀번호를 변경해주세요</h5><br>";
				session.setAttribute("sTempPwd", value);
			}
			
			content += "<p><img src=\"cid:10.jpg\" width='500px'></p>";//cid: 예약어
			content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen'>JavaGroupS2</a></p>";
			content += "<hr>";
			
			messageHelper.setText(content, true); //메일 내용 true 덮어쓰기
			
			FileSystemResource file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/10.jpg"));//경로를 읽어오는 객체?
			
			messageHelper.addInline("10.jpg", file); //이게 아래 있어야 한다
			
			//메일 전송하기
			mailSender.send(message);
			
	}
	
	//파일 복제 메소드
	public void fileCopyCheck(String oriFilePath, String copyFilePath) {
	 	File oriFile = new File(oriFilePath);
    File copyFile = new File(copyFilePath);

    try {
      FileInputStream  fis = new FileInputStream(oriFile);
      FileOutputStream fos = new FileOutputStream(copyFile);

      byte[] buffer = new byte[2048];
      int count = 0;
      while((count = fis.read(buffer)) != -1) {
        fos.write(buffer, 0, count);
      }
      fos.flush();
      fos.close();
      fis.close();
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
	}
	
  // JSON 응답을 생성하는 메서드-ckeditor용
  public String createJsonResponse(String originalFilename, int uploaded, String url) {
      Map<String, Object> uploadResponse = new HashMap<>();
      uploadResponse.put("originalFilename", originalFilename);
      uploadResponse.put("uploaded", uploaded);
      uploadResponse.put("url", url);

      Gson gson = new Gson();
      return gson.toJson(uploadResponse);
  }
	
}
