package io.codeworks.file.monitor.core.test.util;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;

public class TestUtil {

    public static final long DELAY = 100;

    public static Path createRootDir() throws Exception {

        Path parent = Paths.get(System.getProperty("user.home"));

        return createDirIn(parent);
    }

    public static Path createDirIn(Path dir) throws Exception {

        Path path = Files.createTempDirectory(dir, "fm-");

        Thread.sleep(DELAY);

        return path;
    }

    public static Path createFileIn(Path dir) throws Exception {

        Path path = Files.createTempFile(dir, "fm-", ".file");

        Thread.sleep(DELAY);

        return path;
    }

    public static void appendToFile(Path file) throws Exception {

        try(PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(file.toFile(), true)))) {
            out.print(".");
        }
        catch(IOException e) {
        }

        Thread.sleep(DELAY);
    }

    public static void delete(Path entry) throws Exception {

        if(Files.isDirectory(entry)) {
            Files.walkFileTree(entry, new SimpleFileVisitor<Path>() {

                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {

                    Files.delete(file);

                    return FileVisitResult.CONTINUE;
                }

                @Override
                public FileVisitResult postVisitDirectory(Path dir, IOException e) throws IOException {

                    Files.delete(dir);

                    return FileVisitResult.CONTINUE;
                }

            });
        }
        else {
            Files.delete(entry);
        }

        Thread.sleep(DELAY);
    }
}
