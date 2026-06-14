import com.ericsson.otp.erlang.*;

/**
 * Java-клиент, который через JInterface отправляет запрос
 * к Erlang-процессу factorial_server и получает ответ.
 *
 * Запуск: java -cp ".:$JINTERFACE_JAR" FactorialClient
 */
public class FactorialClient {
    public static void main(String[] args) throws Exception {
        String cookie   = "democookie";
        String nodeName = "javaclient";
        String erlNode  = "erlserver@localhost";

        OtpNode node = new OtpNode(nodeName, cookie);
        OtpMbox mbox = node.createMbox();

        System.out.println("[FactorialClient] Java node: " + node.node());

        int[] testValues = {0, 1, 5, 10, 12};

        for (int n : testValues) {
            // Формируем сообщение {self(), N}
            OtpErlangObject[] msg = {
                mbox.self(),
                new OtpErlangLong(n)
            };
            mbox.send("factorial_server", erlNode, new OtpErlangTuple(msg));

            // Ожидаем ответ {ok, Result}
            OtpErlangTuple reply = (OtpErlangTuple) mbox.receive(5000);
            if (reply == null) {
                System.out.println("[FactorialClient] ERROR: timeout for n=" + n);
                continue;
            }
            long result = ((OtpErlangLong) reply.elementAt(1)).longValue();
            System.out.println("[FactorialClient] fact(" + n + ") = " + result);
        }

        // Останавливаем сервер
        mbox.send("factorial_server", erlNode,
                  new OtpErlangAtom("stop"));
        System.out.println("[FactorialClient] Done.");
        node.close();
    }
}
