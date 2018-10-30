 package com.is.eus.dao.support;

 import com.is.eus.model.ui.FunctionTree;
 import com.is.eus.model.ui.SystemFunction;
 import java.io.IOException;
 import java.io.InputStream;
 import java.util.Collection;
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

 public class XmlSystemFunctionProvider
   implements SystemFunctionsProvider
 {
   private static final Logger log = Logger.getLogger(XmlSystemFunctionProvider.class);
   private Document systemFunctionsDoc;
   private SystemFunctions systemFunctions;
   private String xmlFilePath;

   public String getXmlFilePath()
   {
     return this.xmlFilePath;
   }

   public void setXmlFilePath(String xmlFilePath) {
     this.xmlFilePath = xmlFilePath;
   }

   public FunctionTree lookup(String category) {
     log.info("looking up for:" + category);
     return this.systemFunctions.lookup(category);
   }

   public void init() {
     InputStream input = getClass().getClassLoader().getResourceAsStream(this.xmlFilePath);
     log.info("loading system funtions from xml config file:" + input.toString());
     InputSource source = new InputSource(input);
     DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
     try
     {
       DocumentBuilder builder = factory.newDocumentBuilder();
       this.systemFunctionsDoc = builder.parse(source);
     } catch (ParserConfigurationException e) {
       log.fatal("Loading System Funtions config error.");
       e.printStackTrace();
     } catch (SAXException e) {
       log.fatal("Loading System Funtions config error.");
       e.printStackTrace();
     } catch (IOException e) {
       log.fatal("Loading System Funtions config error.");
       e.printStackTrace();
     }
     build();
   }

   private void build() {
     this.systemFunctions = new SystemFunctions();
     NodeList categories = this.systemFunctionsDoc.getElementsByTagName("category");
     for (int i = 0; i < categories.getLength(); i++) {
       Element category = (Element)categories.item(i);
       NodeList functions = category.getChildNodes();
       String cateName = category.getAttribute("id");
       if (log.isDebugEnabled()) {
         log.debug("parsing CATEGORY:" + cateName);
       }

       FunctionTree tree = new FunctionTree();
       tree.setId(cateName);

       SystemFunction categoryFunction = new SystemFunction();
       categoryFunction.setId(cateName);
       categoryFunction.setTitle(category.getAttribute("title"));

       tree.setRoot(categoryFunction);

       for (int j = 0; j < functions.getLength(); j++) {
         Node node = functions.item(j);
         if (node.getNodeName().equalsIgnoreCase("function")) {
           Element function = (Element)node;
           SystemFunction sf = buildFunctionTree(function);
           tree.addFunction(categoryFunction.getId(), sf);
         }
       }
       this.systemFunctions.addFunctionTree(tree);
     }
   }

   private SystemFunction buildFunctionTree(Element element) {
     SystemFunction function = new SystemFunction();
     function.setId(element.getAttribute("id"));
     function.setTitle(element.getAttribute("title"));
     if (element.hasAttribute("url")) {
       function.setUrl(element.getAttribute("url"));
     }

     if (log.isDebugEnabled()) {
       log.debug("parsing FUNCTION:" + function.getId());
     }

     NodeList subFunctions = element.getChildNodes();
     for (int i = 0; i < subFunctions.getLength(); i++) {
       Node node = subFunctions.item(i);
       if (node.getNodeName().equalsIgnoreCase("function")) {
         Element sub = (Element)node;
         function.addChild(buildFunctionTree(sub));
       }
     }
     return function;
   }

   public Collection<SystemFunction> categories()
   {
     return this.systemFunctions.getAllCategories();
   }
 }



