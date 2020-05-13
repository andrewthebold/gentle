import styles from "./ExplainHeader.module.scss";

export enum ExplainIcon {
  airplane,
  reply,
  shield,
}

interface Props {
  icon: ExplainIcon;
  text: string;
}

const ExplainHeader = (props: Props) => {
  const classNames = [styles.header];

  switch (props.icon) {
    case ExplainIcon.airplane:
      classNames.push(styles["header--airplane"]);
      break;
    case ExplainIcon.reply:
      classNames.push(styles["header--reply"]);
      break;
    case ExplainIcon.shield:
      classNames.push(styles["header--shield"]);
      break;
  }

  return <h2 className={classNames.join(" ")}>{props.text}</h2>;
};

export default ExplainHeader;
