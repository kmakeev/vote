# Generated by Django 4.2.5 on 2023-09-25 10:59

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("vote", "0007_remove_votingprocess_answers_votingprocess_answers"),
    ]

    operations = [
        migrations.RenameField(
            model_name="meeting",
            old_name="registrationProccess",
            new_name="registrationProcess",
        ),
        migrations.RenameField(
            model_name="meeting", old_name="votingProccess", new_name="votingProcess",
        ),
    ]