//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.is.eus.web.action.system;

import com.opensymphony.xwork2.ActionSupport;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Map;
import java.util.Random;
import javax.imageio.ImageIO;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.struts2.interceptor.SessionAware;

public class LoginValidation extends ActionSupport implements SessionAware {
    private static final long serialVersionUID = 6557780966794025365L;
    private final int TYPE_NUMBER = 0;
    private final int TYPE_LETTER = 1;
    private final int TYPE_MULTIPLE = 2;
    private int width = 56;
    private int height = 22;
    private int count = 4;
    private int type = 0;
    private String validate_code;
    private Random random = new Random();
    private Font font;
    private int line;
    private Map<String, Object> session;
    private ByteArrayOutputStream output;

    public LoginValidation() {
        this.font = new Font("Courier New", 1, this.width / this.count);
        this.line = 200;
    }

    public ByteArrayOutputStream getOutput() {
        return this.output;
    }

    private String getOneChar(int type) {
        String result = null;
        switch(type) {
            case 0:
                result = String.valueOf(this.random.nextInt(10));
                break;
            case 1:
                result = String.valueOf((char)(this.random.nextInt(26) + 65));
                break;
            case 2:
                if(this.random.nextBoolean()) {
                    result = String.valueOf(this.random.nextInt(10));
                } else {
                    result = String.valueOf((char)(this.random.nextInt(26) + 65));
                }
                break;
            default:
                result = null;
        }

        if(result == null) {
            throw new NullPointerException("获取验证码错误");
        } else {
            return result;
        }
    }

    private String getValidateCode(int size, int type) {
        StringBuffer validate_code = new StringBuffer();

        for(int i = 0; i < size; ++i) {
            validate_code.append(this.getOneChar(type));
        }

        return validate_code.toString();
    }

    private Color getRandColor(int from, int to) {
        Random random = new Random();
        if(to > 255) {
            from = 255;
        }

        if(to > 255) {
            to = 255;
        }

        int rang = Math.abs(to - from);
        int r = from + random.nextInt(rang);
        int g = from + random.nextInt(rang);
        int b = from + random.nextInt(rang);
        return new Color(r, g, b);
    }

    public String validation() throws IOException {
        BufferedImage image = new BufferedImage(this.width, this.height, 1);
        Graphics g = image.getGraphics();
        g.setColor(this.getRandColor(200, 250));
        g.fillRect(0, 0, this.width, this.height);
        g.setColor(this.getRandColor(160, 200));

        int i;
        int x;
        int y;
        for(i = 0; i < this.line; ++i) {
            x = this.random.nextInt(this.width);
            y = this.random.nextInt(this.height);
            int xl = this.random.nextInt(12);
            int yl = this.random.nextInt(12);
            g.drawLine(x, y, x + xl, y + yl);
        }

        g.setFont(this.font);
        this.validate_code = this.getValidateCode(this.count, this.type);
        this.session.put("validate_code", this.validate_code);

        for(i = 0; i < this.count; ++i) {
            g.setColor(new Color(20 + this.random.nextInt(110), 20 + this.random.nextInt(110), 20 + this.random.nextInt(110)));
            x = this.width / this.count * i;
            y = (this.height + this.font.getSize()) / 2 - 5;
            g.drawString(String.valueOf(this.validate_code.charAt(i)), x, y);
        }

        g.dispose();
        this.output = new ByteArrayOutputStream();
        ImageIO.write(image, "JPEG", this.output);
        return "success";
    }

    public void setSession(Map<String, Object> session) {
        this.session = session;
    }
}
