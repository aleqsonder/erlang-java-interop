import com.ericsson.otp.erlang.*;
import java.io.IOException;

public class Hello {
	public static void main(String[] args) throws IOException {
		final var node = new OtpNode("java");
		final var mbox = node.createMbox("hello");
		var running = true;

		System.err.println("Waiting for incoming messages...");
		
		while (running) {
			try {
				final var msg = mbox.receive();
				System.out.println("received: " + msg.toString());

				if (msg instanceof OtpErlangTuple) {
					final var parts = (OtpErlangTuple)msg;
					final var pid = (OtpErlangPid)parts.elementAt(0);
					final var content = parts.elementAt(1);

					if (content.toString().equals("\"stop\"")) {
						System.err.println("stopping...");
						running = false;
					} else {
						mbox.send(pid, content);
					}
				}
			} catch (Exception e) {
				System.err.println(e.toString());
				e.printStackTrace();
				running = false;
			}
		}
	}
}
