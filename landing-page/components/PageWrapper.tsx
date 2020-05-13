import styles from "./PageWrapper.module.scss";

interface Props {
  children: React.ReactNode;
}

const PageWrapper = (props: Props) => (
  <div className={styles.container}>{props.children}</div>
);

export default PageWrapper;
