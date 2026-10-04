package runner;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Ejemplos:
 *   ./gradlew test -Dkarate.options="--tags @smoke"
 *   ./gradlew test -Dkarate.options="--tags @regression --tags ~@slow" -Dkarate.env=qa
 */
class KarateRunner {

    private static final String FEATURES_PATH = "classpath:features";
    private static final String REPORT_DIR = "target/karate-reports";

    @Test
    void runTests() {
        int threads = Integer.getInteger("karate.threads", 2);

        Results results = Runner.path(FEATURES_PATH)
                .tags("~@ignore")
                .reportDir(REPORT_DIR)
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .parallel(threads);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}