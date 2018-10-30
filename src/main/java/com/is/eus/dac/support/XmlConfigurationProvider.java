 package com.is.eus.dac.support;

 import com.is.eus.dac.ConfigurationProvider;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.dac.Group;
 import com.is.eus.pojo.dac.Role;
 import com.is.eus.pojo.dac.User;
 import java.io.IOException;
 import java.io.InputStream;
 import java.util.Collection;
 import java.util.HashMap;
 import java.util.HashSet;
 import java.util.Map;
 import java.util.Set;
 import javax.xml.parsers.DocumentBuilder;
 import javax.xml.parsers.DocumentBuilderFactory;
 import javax.xml.parsers.ParserConfigurationException;
 import org.apache.log4j.Logger;
 import org.w3c.dom.Document;
 import org.w3c.dom.Element;
 import org.w3c.dom.Node;
 import org.w3c.dom.NodeList;
 import org.xml.sax.InputSource;
 import org.xml.sax.SAXException;

 public class XmlConfigurationProvider
   implements ConfigurationProvider
 {
   private static final Logger log = Logger.getLogger(XmlConfigurationProvider.class);

   private Map<String, Role> roles = new HashMap();

   private Map<String, Group> groups = new HashMap();
   private Document document;
   private String configFilePath;

   public String getConfigFilePath()
   {
     return this.configFilePath;
   }

   public void setConfigFilePath(String configFilePath) {
     this.configFilePath = configFilePath;
   }

   public void init()
   {
     InputStream input = getClass().getClassLoader().getResourceAsStream(this.configFilePath);
     log.info("DAC CONFIG:" + input.toString());
     InputSource source = new InputSource(input);
     DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
     try
     {
       DocumentBuilder builder = factory.newDocumentBuilder();
       this.document = builder.parse(source);
       build();
     } catch (ParserConfigurationException e) {
       log.fatal("Initialize Provider Error." + e.getMessage());
     } catch (SAXException e) {
       log.fatal("Initialize Provider Error." + e.getMessage());
     } catch (IOException e) {
       log.fatal("Initialize Provider Error." + e.getMessage());
     }
   }

   private void build()
   {
     NodeList roles = this.document.getElementsByTagName("role");
     for (int i = 0; i < roles.getLength(); i++) {
       Node roleNode = roles.item(i);
       if (roleNode.getNodeName().equals("role")) {
         Element eleRole = (Element)roleNode;
         String roleName = eleRole.getAttribute("name");
         String roleId = eleRole.getAttribute("id");
         if (log.isDebugEnabled()) {
           log.debug("parsing role:" + eleRole.getAttribute("name"));
         }
         Role role = new Role();
         role.setId(roleId);
         role.setName(roleName);
         this.roles.put(role.getId(), role);
       }
     }
     NodeList groups = this.document.getElementsByTagName("group");
     for (int j = 0; j < groups.getLength(); j++) {
       Node groupNode = groups.item(j);
       if (groupNode.getNodeName().equals("group")) {
         Element eleGroup = (Element)groupNode;
         String groupName = eleGroup.getAttribute("name");
         String groupId = eleGroup.getAttribute("id");
         if (log.isDebugEnabled()) {
           log.info("parsing group:" + groupName);
         }
         Group group = new Group();
         group.setId(groupId);
         group.setName(groupName);
         group.setDescription(eleGroup.getAttribute("description"));
         String ref = eleGroup.getAttribute("role-ref");
         Role refrole = (Role)this.roles.get(ref);
         if (refrole != null) {
           group.setRole(refrole);
         }
         Set userset = new HashSet();

         NodeList users = eleGroup.getElementsByTagName("user");
         for (int k = 0; k < users.getLength(); k++) {
           Node userNode = users.item(k);
           if (!userNode.getNodeName().equals("user"))
             continue;
           Element eleUser = (Element)userNode;

           User user = new User();
           user.setId(eleUser.getAttribute("id"));
           userset.add(user);
         }
         group.setUsers(userset);

         this.groups.put(group.getId(), group);
       }
     }
   }

   public void reload() {
     this.groups.clear();
     this.roles.clear();
     init();
   }

   public User getUser(String id)
   {
     return null;
   }

   public void update(Entity entity)
   {
   }

   public User getUserByName(String name)
   {
     return null;
   }

   public Role getRole(String role)
   {
     return null;
   }

   public <T> Collection<T> list(Class<T> cls)
   {
     return null;
   }

   public <T> T get(Class<T> cls, String id)
   {
     return null;
   }
 }
