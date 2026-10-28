package dualist.pipes;

import cc.mallet.pipe.Pipe;
import cc.mallet.extract.StringSpan;
import cc.mallet.extract.StringTokenization;
import cc.mallet.types.Instance;
import cc.mallet.types.TokenSequence;

import org.chasen.mecab.Tagger;
import org.chasen.mecab.Node;

public class SimpleMecabPipe extends Pipe
{
    static {
        try {
            System.loadLibrary("mecab-java");
        } catch (UnsatisfiedLinkError e) {
            System.err.println("ERROR: Failed to load mecab-java native code.");
            System.err.println(e);
            System.exit(1);
        }
    }

    public Instance pipe (Instance carrier)
    {
        CharSequence input = (CharSequence) carrier.getData();
        String string = input.toString();
        Tagger tagger = new Tagger();
        Node node = tagger.parseToNode(string);
        int cursor = 0;
        TokenSequence ts = new StringTokenization(input);
        while (node != null) {
            node = node.getNext();
            if (node == null) break;
            String[] f = node.getFeature().split(",");
            if (f[0].equals("名詞") &&
                !f[1].equals("数") && !f[1].equals("サ変接続") && !f[1].equals("接尾") ||
                f[0].equals("未知語")) {
                String surface = node.getSurface();
                cursor = string.indexOf(surface, cursor);
                ts.add (new StringSpan(input, cursor, cursor + surface.length()));
            }
        }
        carrier.setData(ts);
        return carrier;
    }
}
