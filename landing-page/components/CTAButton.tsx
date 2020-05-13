import styles from "./CTAButton.module.scss";

const CTAButton = () => (
  <div className={styles.ctaWrapper}>
    <a
      className={styles.ctaButton}
      href="#LINK_REMOVED"
      target="_blank"
      rel="noopener noreferrer"
    >
      Get the iOS beta
    </a>
    <div className={[styles.rect, styles.rect1].join(" ")}></div>
    <div className={[styles.rect, styles.rect2].join(" ")}></div>
    <div className={[styles.circle, styles.circle1].join(" ")}></div>
    <div className={[styles.circle, styles.circle2].join(" ")}></div>
    <div className={[styles.plus, styles.plus1].join(" ")}></div>
    <div className={[styles.plus, styles.plus2].join(" ")}></div>
    <div className={[styles.dot, styles.dot1].join(" ")}></div>
    <div className={[styles.dot, styles.dot2].join(" ")}></div>
    <div className={[styles.dot, styles.dot3].join(" ")}></div>
    <div className={[styles.dot, styles.dot4].join(" ")}></div>
    <div className={[styles.dot, styles.dot5].join(" ")}></div>
    <div className={[styles.dot, styles.dot6].join(" ")}></div>
    <div className={[styles.dot, styles.dot7].join(" ")}></div>
  </div>
);

export default CTAButton;
