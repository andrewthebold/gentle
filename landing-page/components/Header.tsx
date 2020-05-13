import styles from "./Header.module.scss";
import Link from "next/link";

const Header = () => (
  <header className={styles.header}>
    <Link href="/">
      <a className={styles.label}>
        Gentle <span className={styles.beta}>Beta</span>
      </a>
    </Link>
  </header>
);

export default Header;
