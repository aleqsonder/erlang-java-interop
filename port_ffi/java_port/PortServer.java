import java.io.*;

/**
 * Java-процесс, запущенный через Erlang Port.
 * Протокол: {packet, 2} — 2-байтовый заголовок длины + тело.
 * Формат запроса:  "fib:<N>\n"  или  "fact:<N>\n"
 * Формат ответа: "<result>\n"
 */
public class PortServer {

    private static long fib(int n) {
        if (n <= 0) return 0;
        if (n == 1) return 1;
        long a = 0, b = 1;
        for (int i = 2; i <= n; i++) { long c = a + b; a = b; b = c; }
        return b;
    }

    private static long fact(int n) {
        if (n <= 0) return 1;
        long r = 1;
        for (int i = 2; i <= n; i++) r *= i;
        return r;
    }

    public static void main(String[] args) throws IOException {
        DataInputStream  in  = new DataInputStream(System.in);
        DataOutputStream out = new DataOutputStream(System.out);

        // Отключаем буферизацию stderr для отладочных сообщений
        PrintStream err = new PrintStream(System.err, true);

        err.println("[PortServer] Started, waiting for packets...");

        while (true) {
            // Читаем 2-байтовый заголовок
            int len;
            try {
                len = in.readUnsignedShort();
            } catch (EOFException e) {
                err.println("[PortServer] EOF, shutting down.");
                break;
            }

            byte[] buf = new byte[len];
            in.readFully(buf);
            String request = new String(buf).trim();
            err.println("[PortServer] Got: '" + request + "'");

            String response;
            try {
                String[] parts = request.split(":");
                String   op    = parts[0].trim();
                int      n     = Integer.parseInt(parts[1].trim());
                long     result;
                if (op.equals("fib")) {
                    result = fib(n);
                } else if (op.equals("fact")) {
                    result = fact(n);
                } else {
                    response = "error:unknown_op";
                    writePacket(out, response);
                    continue;
                }
                response = op + ":" + n + "=" + result;
            } catch (Exception e) {
                response = "error:" + e.getMessage();
            }

            err.println("[PortServer] Sending: '" + response + "'");
            writePacket(out, response);
        }
    }

    private static void writePacket(DataOutputStream out, String s) throws IOException {
        byte[] data = s.getBytes();
        out.writeShort(data.length);
        out.write(data);
        out.flush();
    }
}
