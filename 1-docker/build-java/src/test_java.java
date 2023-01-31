package bin;

/**
 * @author carles.mateo
 * @editor ra.sla
 */
public class test_java {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {

        int i_loop1 = 0;
        int i_loop2 = 0;
        int i_loop3 = 0;
        int i_counter = 0;
        long l_counter = 0;

        String s_version = System.getProperty("java.version");
        System.out.println("Java Version: " + s_version);

        for (i_loop1 = 0; i_loop1 < 10; i_loop1++) {
            System.out.println("loop1: " + i_loop1);
            for (i_loop2 = 0; i_loop2 < 32000; i_loop2++) {
                for (i_loop3 = 0; i_loop3 < 32000; i_loop3++) {
                    i_counter++;
                    l_counter++;

                    if (i_counter > 50) {
                        i_counter = 0;
                    }
                }
            }
        }

        System.out.println("i_counter: " + i_counter);
        System.out.println("l_counter: " + l_counter);
    }

}
