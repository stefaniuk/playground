package io.codeworks.file.explorer.commons.test.impl;

import io.codeworks.file.explorer.commons.exception.FileExplorerException;
import io.codeworks.file.explorer.commons.impl.LocalFileSystem;

import java.net.URI;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

public class MockLocalFileSystem extends LocalFileSystem {

    public MockLocalFileSystem() {

        Path path = FileSystems.getDefault().getPath("mock-local-file-system.zip").toAbsolutePath();
        FileSystem fs = createFileSystem(path);
        setFileSystem(fs);
    }

    public FileSystem createFileSystem(Path path) {

        FileSystem fs = null;

        try {
            Map<String, String> env = new HashMap<String, String>();
            env.put("create", String.valueOf(!path.toFile().exists()));
            URI uri = new URI("jar:" + path.toUri().getScheme(), path.toUri().getPath(), null);
            System.out.println(uri);
            fs = FileSystems.newFileSystem(uri, env);
        }
        catch(Exception e) {
            throw new FileExplorerException("Cannot create filesystem", e);
        }

        return fs;
    }

}
