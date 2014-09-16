package io.codeworks.daemon;

import java.io.IOException;

import org.apache.commons.daemon.Daemon;
import org.apache.commons.daemon.DaemonContext;
import org.apache.commons.daemon.DaemonInitException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SampleService implements Runnable, Daemon {

    private static Logger logger = LoggerFactory.getLogger(SampleService.class);

    private static volatile Thread thread;

    private DaemonContext context;

    public static void main(String[] args) throws IOException {

        if(args.length > 0) {
            if(args[0].equals("start")) {
                start(args);
            }
            else if(args[0].equals("stop")) {
                stop(args);
            }
        }
    }

    public static void start(String[] args) {

        logger.debug("start daemon");

        if(thread == null || !thread.isAlive()) {
            thread = new Thread(new SampleService());
            thread.start();
        }
    }

    public static void stop(String[] args) {

        logger.debug("stop daemon");

        if(thread != null) {
            thread.interrupt();
        }
    }

    @Override
    public void run() {

        while(true) {
            try {
                logger.debug("working...");
                Thread.sleep(1000);
            }
            catch(InterruptedException e) {
                break;
            }
        }
    }

    @Override
    public void init(DaemonContext context) throws DaemonInitException, Exception {

        this.context = context;
    }

    @Override
    public void start() throws Exception {

        start(context.getArguments());
    }

    @Override
    public void stop() throws Exception {

        stop(context.getArguments());
    }

    @Override
    public void destroy() {

    }

}
