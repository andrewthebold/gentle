import Head from "next/head";
import Header from "../components/Header";
import PageWrapper from "../components/PageWrapper";
import Footer from "../components/Footer";
import ShutdownLetter from "../components/ShutdownLetter";

const Shutdown = () => (
  <>
    <Head>
      <title key="title">Gentle: Shutdown (May 2020)</title>
    </Head>

    <PageWrapper>
      <Header />
    </PageWrapper>

    <main>
      <PageWrapper>
        <ShutdownLetter />
      </PageWrapper>
    </main>

    <PageWrapper>
      <Footer />
    </PageWrapper>
  </>
);

export default Shutdown;
