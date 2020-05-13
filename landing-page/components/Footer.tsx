import styles from "./Footer.module.scss";
import Link from "next/link";
import ShutdownCard from "./ShutdownCard";

const Footer = () => (
  <footer className={styles.footer}>
    <div className={styles.ctaWrapper}>
      <ShutdownCard />
    </div>

    <img
      className={styles.footerLogo}
      src="/images/footer_logo.svg"
      alt="Gentle Logo"
    />
    <nav className={styles.footerNav}>
      <ul>
        <li>
          <Link href="/terms">
            <a>Terms</a>
          </Link>
        </li>
        <li>
          <Link href="/privacy">
            <a>Privacy</a>
          </Link>
        </li>
        <li>
          <a
            href="mailto:EMAIL_REMOVED"
            target="_blank"
            rel="noopener noreferrer"
          >
            Contact
          </a>
        </li>
      </ul>
    </nav>
    <p className={styles.copy}>
      <a
        href="https://andrewlee.design/"
        target="_blank"
        rel="noopener noreferrer"
      >
        Andrew Lee
      </a>{" "}
      &copy; 2020
    </p>
  </footer>
);

export default Footer;
