import java.util.UUID;

public class Main {

    public static void main(String[] args) {
        for (int i = 0; i < 23; i++) {
            String uniqueID = UUID.randomUUID().toString().substring(0, 7);
            System.out.println(uniqueID);
        }
    }
}
