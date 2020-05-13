import Document, { Html, Head, Main, NextScript } from "next/document";

class MyDocument extends Document {
  static async getInitialProps(ctx) {
    const initialProps = await Document.getInitialProps(ctx);
    return { ...initialProps };
  }

  render() {
    return (
      <Html lang="en">
        <Head>
          <meta charSet="utf-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />

          <meta name="theme-color" content="#007cff" />

          <meta
            name="description"
            content="Give and get kindness. A social app where you send and receive messages of compassion."
          />

          {/* Twitter Cards */}
          <meta name="twitter:card" content="summary_large_image" />
          <meta name="twitter:site" content="@<TWITTER_USERNAME_REMOVED>" />
          <meta name="twitter:url" content="<DOMAIN_REMOVED>" />
          <meta
            name="twitter:title"
            content="Gentle: A social app for compassion"
          />
          <meta
            name="twitter:description"
            content="Give and get kindness. A social app where you send and receive messages of compassion."
          />
          <meta name="twitter:image" content="<DOMAIN_REMOVED>/og_card.png" />
          <meta
            name="twitter:image:alt"
            content="App icon for Gentle, the social app for compassion"
          />

          <meta name="twitter:card" content="summary_large_image" />
          <meta
            property="og:site_name"
            content="Gentle: A social app for compassion"
          />

          {/* Facebook OG */}
          <meta property="og:url" content="<DOMAIN_REMOVED>" />
          <meta property="og:type" content="website" />
          <meta
            property="og:title"
            content="Gentle: A social app for compassion"
          />
          <meta property="og:image" content="<DOMAIN_REMOVED>/og_card.png" />
          <meta
            property="og:image:alt"
            content="App icon for Gentle, the social app for compassion"
          />
          <meta
            property="og:description"
            content="Give and get kindness. A social app where you send and receive messages of compassion."
          />
          <meta property="og:site_name" content="Gentle" />
          <meta property="og:locale" content="en_US" />

          <link rel="icon" href="/favicon.png" />
          <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
            rel="stylesheet"
          />
        </Head>
        <body>
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

export default MyDocument;
