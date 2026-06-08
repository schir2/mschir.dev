<template>
  <div class="flex flex-col gap-6">
    <p class="leading-relaxed text-muted-color">
      The customer portal started as a last-minute scope addition — "the customers want to log in and see their jobs" — which is one of those requirements that sounds simple and isn't. By the time we mapped out what "see their jobs" actually meant (which jobs, what status, what documents, what history, who can see what), it had become the second-largest piece of work in the project.
    </p>
    <p class="leading-relaxed text-muted-color">
      What made it complicated wasn't the UI. The UI is straightforward: a list of jobs, a detail view, a status timeline. What made it complicated was the authorization model. A customer can belong to multiple companies. A company can have multiple contacts. Some contacts should see everything; others should only see their own jobs. The foreman for a chain of locations needs a cross-location view that the individual site managers don't get.
    </p>
    <p class="leading-relaxed text-muted-color">
      We ended up with a three-tier model: Customer (the company), Contact (the individual), and Role (their access level within that customer). Every query for portal data runs through a view that enforces this — the application layer never touches raw job data on behalf of a portal user. The database is the authorization boundary, not the API.
    </p>
    <h2>The login question</h2>
    <p class="leading-relaxed text-muted-color">
      We chose not to build our own auth. The customer portal uses the same Supabase authentication stack as the internal system, with a separate user pool and a row-level security policy that limits portal users to their own customer's data. This was a deliberate choice: building a custom auth flow for external users is one of the most common sources of security debt in bespoke business software, and we didn't have a reason to do it.
    </p>
  </div>
</template>
