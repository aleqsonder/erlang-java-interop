import com.ericsson.otp.erlang.*;

/**
 * Java-узел, зарегистрированный как Erlang-нода.
 * Принимает сообщение {Pid, N} и отвечает {ok, fib(N)}.
 *
 * Запуск: java -cp ".:$JINTERFACE_JAR" FibServer
 * Вызов из Erlang:
 *   {fibserver, 'javanode@hostname'} ! {self(), 10},
 *   receive {ok, R} -> io:format("fib(10) = ~p~n", [R]) end.
 */
public class FibServer {

    public static long fib(int n) {
        if (n <= 0) return 0;
        if (n == 1) return 1;
        long a = 0, b = 1;
        for (int i = 2; i <= n; i++) {
            long c = a + b;
            a = b;
            b = c;
        }
        return b;
    }

    public static void main(String[] args) throws Exception {
        String nodeName = "javanode";
        String cookie   = "democookie";

        OtpNode node = new OtpNode(nodeName, cookie);
        OtpMbox mbox = node.createMbox("fibserver");

        System.out.println("[FibServer] Node started: " + node.node());
        System.out.println("[FibServer] Mailbox: fibserver  Cookie: " + cookie);
        System.out.println("[FibServer] Waiting for {Pid, N} messages...");

        // Обрабатываем ровно одно сообщение и завершаемся (для демонстрации)
        OtpErlangObject msg = mbox.receive(5000);
        if (msg == null) {
            System.out.println("[FibServer] Timeout — no message received.");
            System.exit(1);
        }

        System.out.println("[FibServer] Received: " + msg);

        OtpErlangTuple tuple = (OtpErlangTuple) msg;
        OtpErlangPid  from  = (OtpErlangPid)   tuple.elementAt(0);
        int           n     = (int) ((OtpErlangLong) tuple.elementAt(1)).longValue();

        long result = fib(n);
        System.out.println("[FibServer] fib(" + n + ") = " + result);

        OtpErlangObject[] reply = {
            new OtpErlangAtom("ok"),
            new OtpErlangLong(result)
        };
        mbox.send(from, new OtpErlangTuple(reply));
        System.out.println("[FibServer] Reply sent. Shutting down.");
    }
}
