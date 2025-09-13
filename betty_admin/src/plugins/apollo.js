import { ApolloClient, createHttpLink, InMemoryCache } from '@apollo/client/core';
import { DefaultApolloClient } from '@vue/apollo-composable';

const httpLink = createHttpLink({
  uri: 'http://localhost:8000/graphql',
});

const cache = new InMemoryCache();

export const apolloClient = new ApolloClient({
  link: httpLink,
  cache,
});

export const apolloPlugin = {
  install(app) {
    app.provide(DefaultApolloClient, apolloClient);
  },
};
