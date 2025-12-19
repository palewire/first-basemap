# Introducing Actions

Actions is an online tool for scheduling, running, and monitoring computer programming scripts in a far-off data center without human intervention. It is one of the commercial services offered by [GitHub](https://en.wikipedia.org/wiki/GitHub), Microsoft’s multi-faceted software development site.

The tasks it executes are configured and run alongside the code that programmers store on the platform, allowing quick and easy development. Due to its low cost and tight integration with the popular code-management system, Actions has emerged as one of the most popular automation tools.

[![Actions homepage](_static/actions-homepage.png)](https://github.com/features/actions)

GitHub created the tool primarily to help coders with [continuous integration](https://en.wikipedia.org/wiki/Continuous_integration) and [continuous deployment](https://en.wikipedia.org/wiki/Continuous_deployment) practices that automate the review, testing and circulation of freshly written code.

For example, a routine set of Actions vets every change made to the codebase of Microsoft's [Visual Studio Code](https://github.com/microsoft/vscode), a popular open-source project managed via GitHub.

Each time a developer submits a patch for review, tests run to ensure nothing breaks. When changes are approved, an Actions task automatically ships out the latest version to users.

[![VS Code actions](_static/vscode-actions.png)](https://github.com/microsoft/vscode/actions)

These routines are common in the software industry, where they strengthen quality control and speed up releases.

However, Actions tasks are not limited to arcane, back-office work. Because they can run any kind of script, computer programmers, including journalists, have found ways to use Actions creatively.

A simple example is the [@ReutersJobs](https://mastodon.palewi.re/@ReutersJobs) social media bot. The project scrapes the job listings from the Reuters website, identifies new openings, generates promotional images and posts notices on social media.

[![@ReutersJobs post](_static/reuters-jobs-post.png)](https://mastodon.palewi.re/@ReutersJobs/113823961066565728)

The bot's code is [hosted on GitHub](https://github.com/palewire/reuters-jobs) where Actions linked to the repository are configured to run a series of Python scripts every six hours. This process that is logged and monitored via [the repository's Actions tab](https://github.com/palewire/reuters-jobs/actions).

[![@ReutersJobs actions](_static/reuters-jobs-actions.png)](https://github.com/palewire/reuters-jobs/actions)

This panel allows you to see the progress of tasks as they execute and review the results of previous runs.

[![@ReutersJobs tasks](_static/reuters-jobs-task.png)](https://github.com/palewire/reuters-jobs/actions/runs/13483141005/job/37670903830)

In this way, reporters at top news organizations routinely use Actions to automate data collection, processing, analysis and publication. This class will teach you some of their techniques. We’ll start with a simple example and then build up to more complex and powerful configurations.
