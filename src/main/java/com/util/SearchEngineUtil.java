package com.util;

import com.model.Template;
import com.model.TemplateDAO;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.*;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.MultiFieldQueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class SearchEngineUtil {
    private static final String INDEX_DIR = System.getProperty("java.io.tmpdir") + "/presenta_lucene_index";
    private static StandardAnalyzer analyzer = new StandardAnalyzer();

    private static Directory getDirectory() throws IOException {
        return FSDirectory.open(Paths.get(INDEX_DIR));
    }

    public static void buildIndex() {
        try (Directory dir = getDirectory();
             IndexWriter writer = new IndexWriter(dir, new IndexWriterConfig(analyzer).setOpenMode(IndexWriterConfig.OpenMode.CREATE))) {
            
            TemplateDAO dao = new TemplateDAO();
            // Fetch all templates to index
            List<Template> templates = dao.searchAndPagingTemplates("", 0, 1, 100000, "newest");
            
            for (Template t : templates) {
                writer.addDocument(createDocument(t));
            }
            writer.commit();
            System.out.println("Lucene Index built successfully. Total documents: " + templates.size());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void addOrUpdateTemplate(Template t) {
        try (Directory dir = getDirectory();
             IndexWriter writer = new IndexWriter(dir, new IndexWriterConfig(analyzer).setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND))) {
            
            writer.updateDocument(new Term("templateID", String.valueOf(t.getTemplateID())), createDocument(t));
            writer.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void deleteTemplate(int templateId) {
        try (Directory dir = getDirectory();
             IndexWriter writer = new IndexWriter(dir, new IndexWriterConfig(analyzer).setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND))) {
            
            writer.deleteDocuments(new Term("templateID", String.valueOf(templateId)));
            writer.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static Document createDocument(Template t) {
        Document doc = new Document();
        doc.add(new StringField("templateID", String.valueOf(t.getTemplateID()), Field.Store.YES));
        if (t.getTitle() != null) doc.add(new TextField("title", t.getTitle(), Field.Store.YES));
        if (t.getDescription() != null) doc.add(new TextField("description", t.getDescription(), Field.Store.NO));
        if (t.getDesignerName() != null) doc.add(new TextField("designerName", t.getDesignerName(), Field.Store.NO));
        if (t.getCoreFeatures() != null) doc.add(new TextField("coreFeatures", t.getCoreFeatures(), Field.Store.NO));
        return doc;
    }

    public static List<Integer> searchTemplates(String keyword) {
        List<Integer> resultIds = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return resultIds;
        }

        try {
            // Check if index exists, if not build it
            if (!DirectoryReader.indexExists(getDirectory())) {
                buildIndex();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        try (Directory dir = getDirectory();
             DirectoryReader reader = DirectoryReader.open(dir)) {
             
            IndexSearcher searcher = new IndexSearcher(reader);
            String[] fields = {"title", "description", "designerName", "coreFeatures"};
            MultiFieldQueryParser parser = new MultiFieldQueryParser(fields, analyzer);
            
            // Allow fuzzy matching
            String[] terms = keyword.trim().split("\\s+");
            StringBuilder fuzzyQuery = new StringBuilder();
            for (String term : terms) {
                // Ensure the term is clean enough for fuzzy query, avoid operators if typed by user
                term = QueryParserUtil.escape(term);
                fuzzyQuery.append(term).append("~1 "); // 1 edit distance
            }
            
            Query query = parser.parse(fuzzyQuery.toString().trim());
            
            TopDocs results = searcher.search(query, 100);
            for (ScoreDoc scoreDoc : results.scoreDocs) {
                Document doc = searcher.doc(scoreDoc.doc);
                resultIds.add(Integer.parseInt(doc.get("templateID")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultIds;
    }
}

class QueryParserUtil {
    public static String escape(String s) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            // These characters are part of the query syntax and must be escaped
            if (c == '\\' || c == '+' || c == '-' || c == '!' || c == '(' || c == ')' || c == ':'
                    || c == '^' || c == '[' || c == ']' || c == '\"' || c == '{' || c == '}' || c == '~'
                    || c == '*' || c == '?' || c == '|' || c == '&' || c == '/') {
                sb.append('\\');
            }
            sb.append(c);
        }
        return sb.toString();
    }
}
