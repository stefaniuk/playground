package io.codeworks.script.launcher.test;

import io.codeworks.script.launcher.GroovyLauncher;
import io.codeworks.script.launcher.test.impl.ProgressEventListener;
import io.codeworks.script.launcher.test.impl.Progress;
import io.codeworks.script.launcher.test.util.TestUtil;

import java.util.List;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mockito;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class GroovyLauncherTest {

    private static final String script = "scripts/ProgressScript.groovy";

    private GroovyLauncher<ProgressEventListener> launcher;

    private ProgressEventListener listener;

    @Before
    public void setUp() throws Exception {

        listener = Mockito.spy(new ProgressEventListener<>());
        launcher = new GroovyLauncher<>(TestUtil.getFileContent(script), listener);
    }

    @Test
    public void test() throws Exception {

        launcher.run("progress");

        // check
        ArgumentCaptor<Progress> captor = ArgumentCaptor.forClass(Progress.class);
        Mockito.verify(listener, Mockito.times(1)).onCreate(captor.capture());
        Mockito.verify(listener, Mockito.times(10)).onProgress(captor.capture(), Mockito.anyInt());
        List<Progress> captured = captor.getAllValues();
        Assert.assertNotEquals(captured.get(0), null);
        for(int i = 1; i <= 10; i++) {
            Assert.assertEquals(captured.get(0), captured.get(i));
        }
    }

}
