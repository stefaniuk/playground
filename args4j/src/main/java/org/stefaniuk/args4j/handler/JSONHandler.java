package org.stefaniuk.args4j.handler;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Handles JSON type.
 * 
 * @author Daniel Stefaniuk
 */
public class JSONHandler extends Handler<Object> {

    private Class<?> type;

    public void setType(Class<?> type) {

        this.type = type;
    }

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {

                // get value from file
                if(value.startsWith("file://")) {
                    File file = new File(value.replace("file://", ""));
                    if(file.exists()) {
                        BufferedReader reader = new BufferedReader(new FileReader(file));
                        String line = null;
                        StringBuilder sb = new StringBuilder();
                        String ls = System.getProperty("line.separator");
                        while((line = reader.readLine()) != null) {
                            sb.append(line);
                            sb.append(ls);
                        }
                        reader.close();
                        value = sb.toString();
                    }
                }

                ObjectMapper mapper = new ObjectMapper();
                if(type.equals(JsonNode.class)) {
                    JsonFactory factory = mapper.getFactory();
                    JsonParser jp = factory.createParser(value);
                    setValue(mapper.readTree(jp));
                }
                else {
                    setValue(mapper.readValue(value, type));
                }
            }
            catch(JsonParseException e) {
                e.printStackTrace();
                throw new CmdLineException("Unable to parse JSON");
            }
            catch(FileNotFoundException e) {
                e.printStackTrace();
                throw new CmdLineException("Unable to open the file");
            }
            catch(IOException e) {
                e.printStackTrace();
                throw new CmdLineException("Unable to convert to JSON object");
            }
        }
        else {
            throw new CmdLineException("Missing string value");
        }
    }

}
