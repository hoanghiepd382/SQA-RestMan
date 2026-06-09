package RTDRestaurant.View.Swing;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;
import java.awt.AlphaComposite;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.Icon;
import javax.swing.JButton;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;
import org.jdesktop.animation.timing.Animator;
import org.jdesktop.animation.timing.TimingTarget;
import org.jdesktop.animation.timing.TimingTargetAdapter;

/**
 * Custom button dùng cho sidebar menu.
 * - MenuButton(Icon, String) : menu cha (có icon + tên menu)
 * - MenuButton(String)       : menu con (chỉ có text)
 */
public class MenuButton extends JButton {

    private int index = -1;

    // --- Ripple effect fields ---
    private Animator animator;
    private int targetSize;
    private float animatSize;
    private Point pressedPoint;
    private float alpha;
    private final Color effectColor = new Color(255, 255, 255, 60);

    // ------------------------------------------------------------------ //
    //  Constructors
    // ------------------------------------------------------------------ //

    /** Constructor cho menu cha: có icon bên trái và tên menu */
    public MenuButton(Icon icon, String text) {
        super(text, icon);
        applyBaseStyle();
        setFont(new Font("sansserif", Font.PLAIN, 14));
        setHorizontalAlignment(SwingConstants.LEFT);
        setIconTextGap(8);
    }

    /** Constructor cho menu con: chỉ có text (thụt vào để phân biệt) */
    public MenuButton(String text) {
        super(text);
        applyBaseStyle();
        setFont(new Font("sansserif", Font.PLAIN, 13));
        setHorizontalAlignment(SwingConstants.LEFT);
        setBorder(new EmptyBorder(5, 45, 5, 5));   // thụt vào so với menu cha
    }

    // ------------------------------------------------------------------ //
    //  Index (dùng để xác định vị trí submenu)
    // ------------------------------------------------------------------ //

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    // ------------------------------------------------------------------ //
    //  Style chung
    // ------------------------------------------------------------------ //

    private void applyBaseStyle() {
        setContentAreaFilled(false);
        setFocusPainted(false);
        setBorderPainted(false);
        setOpaque(false);
        setBorder(new EmptyBorder(5, 10, 5, 5));
        setForeground(new Color(220, 220, 220));
        setCursor(new Cursor(Cursor.HAND_CURSOR));

        // Ripple effect khi nhấn
        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent me) {
                targetSize = Math.max(getWidth(), getHeight()) * 2;
                animatSize = 0;
                pressedPoint = me.getPoint();
                alpha = 0.4f;
                if (animator != null && animator.isRunning()) {
                    animator.stop();
                }
                if (animator != null) {
                    animator.start();
                }
            }

            @Override
            public void mouseEntered(MouseEvent me) {
                setForeground(Color.WHITE);
                repaint();
            }

            @Override
            public void mouseExited(MouseEvent me) {
                setForeground(new Color(220, 220, 220));
                repaint();
            }
        });

        TimingTarget target = new TimingTargetAdapter() {
            @Override
            public void timingEvent(float fraction) {
                if (fraction > 0.5f) {
                    alpha = 1 - fraction;
                }
                animatSize = fraction * targetSize;
                repaint();
            }
        };
        animator = new Animator(350, target);
        animator.setResolution(0);
    }

    // ------------------------------------------------------------------ //
    //  Paint với ripple effect
    // ------------------------------------------------------------------ //

    @Override
    protected void paintComponent(Graphics g) {
        int width = getWidth();
        int height = getHeight();
        BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = img.createGraphics();
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        // Nền trong suốt (menu tự vẽ nền)
        g2.setColor(new Color(0, 0, 0, 0));
        g2.fillRect(0, 0, width, height);

        // Ripple
        if (pressedPoint != null) {
            g2.setColor(effectColor);
            g2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, alpha));
            g2.fillOval(
                (int) (pressedPoint.x - animatSize / 2),
                (int) (pressedPoint.y - animatSize / 2),
                (int) animatSize,
                (int) animatSize
            );
        }
        g2.dispose();
        g.drawImage(img, 0, 0, null);
        super.paintComponent(g);
    }
}
